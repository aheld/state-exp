NodeState = require 'node-state'
###
Verbs
###
inTX = (next) ->
    (data)->
                if (@AccountClient(data.accountID).utility.state == "TX")
                    @goto "Cancel", {state:"checkTX", msg:"Texas Customer"}
                else
                    @goto next, data

hasECF = (next) ->
     (data) ->
                if (@AccountClient(data.accountID).pricing.current.ECF == 0)
                    @goto "Cancel", {state:"checkECF", msg:"ECF = 0"}
                else
                    @goto next

processLetter = ->
    (data) ->
        @goto "Success"
        

class Type12fsm extends NodeState
    states:
        Waiting :
            dropCompleted : (data)->
                @.goto 'CheckTX', data

        CheckTX : 
            Enter : inTX "CheckECF" 

        CheckECF:
            Enter : hasECF "SendLetter"

        SendLetter: 
            Enter: processLetter "Success"

        Success: 
            Enter : (data)-> 
                @StatusUpdate(data, "Success")
                @done

        Cancel:
            Enter: (data) -> 
                @StatusUpdate(data, data['msg'])
                @done

    AccountClient:  ->
         console.log("OVERRIDE ME")

    StatusUpdate:  ->
         console.log("OVERRIDE ME")

type12fsmFactory = ->
    fsm = new Type12fsm
        autostart: true
        intial_state: 'Waiting'
        sync_goto: true
    fsm

module.exports.type12fsm = type12fsmFactory
module.exports.Type12fsm = Type12fsm
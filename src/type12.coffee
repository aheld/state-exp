NodeState = require 'node-state'

class Type12fsm extends NodeState
    states:
        Waiting :
            dropCompleted : (data)->
                @.goto 'CheckTX', data

        Eligibility : 
            Enter : (data) ->
                @goto 'CheckTX'

        CheckTX : 
            Enter : (data) ->
                if (@AccountClient(data.accountID).utility.state == "TX")
                    @goto "Cancel", {state:"checkTX", msg:"Texas Customer"}
                else
                    @goto "CheckECF", data

        CheckECF:
            Enter : (data) ->
                if (@AccountClient(data.accountID).pricing.current.ECF == 0)
                    @goto "Cancel", {state:"checkECF", msg:"ECF = 0"}
                else
                    @goto "SendLetter"

        SendLetter: {}

        Cancel:
            Enter: (data) -> {}

    AccountClient:  ->
         console.log("OVERRIDE ME")

type12fsmFactory = ->
    fsm = new Type12fsm
        autostart: true
        intial_state: 'Waiting'
        sync_goto: true
    fsm

module.exports.type12fsm = type12fsmFactory
module.exports.Type12fsm = Type12fsm
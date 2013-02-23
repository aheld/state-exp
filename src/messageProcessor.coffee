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
        

class MessageProcessor extends NodeState
    states:
        Waiting :
            messageReceived : (data)->
                @.goto 'Processing', data

        Processing : 
            Enter : (data) ->
                @.raise "messageReceived",data

            messageReceived : (data)->
                 @dispatchToFSM(data.message)

        Success: 
            Enter : (data)-> 
                @StatusUpdate(data, "Success")
                @done

        Cancel:
            Enter: (data) -> 
                @StatusUpdate(data, data['msg'])
                @done

    transitions:
        '*':
            '*': (data, callback) ->
                console.log (data || {}).accountID + " leaving " +  @current_state_name + " at " + Date()
                callback(data)

    dispatchToFSM:  ->
         console.log("OVERRIDE ME")


MessageProcessorFactory = ->
    messageProcessor = new MessageProcessor
        autostart: true
        intial_state: 'Waiting'
        sync_goto: true
    messageProcessor

module.exports.MessageProcessorFactory = MessageProcessorFactory
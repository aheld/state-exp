MessageProcessorFactory = require('../src/messageProcessor').MessageProcessorFactory 
NodeState = require 'node-state'

randAcctID = ->
    Math.floor(Math.random() * 10000)
    
describe "Basic event pump", ->
    messageProcessor = {}
    messages = []
    beforeEach ->
        messageProcessor = MessageProcessorFactory()
        messages = [ 
            (dropCompleted:
                accountID:randAcctID()),
            (dropCompleted:
                accountID:randAcctID()),
            (dropCompleted:
                accountID:randAcctID()),
            (dropCompleted:
                accountID:randAcctID())
        ]

    it "Should drain small queue", ->
        spyOn(messageProcessor, 'dispatchToFSM').andReturn(
          handler:1
        )
        messageProcessor.raise('messageReceived', message) for message in messages
        expect(messageProcessor.dispatchToFSM).toHaveBeenCalled()
        expect(messageProcessor.dispatchToFSM.callCount).toEqual(messages.length)        
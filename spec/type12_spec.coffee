fsmLib = require('../src/type12')
NodeState = require 'node-state'
fsmFactory = fsmLib.type12fsm
Type12fsm = fsmLib.Type12fsm

createAccountSpy = (fsm, data = {}) ->
    spyOn(fsm, 'StatusUpdate').andReturn(
        ok:"saved"
        )

    spyOn(fsm, 'AccountClient').andReturn(
        utility:
            state: data["state"] || "TX"
        pricing:
            current:
                ECF: data["ECF"] || 0
        )
    

describe "Basic state machine", ->
    fsm = {}
    beforeEach ->
        fsm = fsmFactory()


    it "Should transition", ->
        createAccountSpy(fsm)
        fsm.raise('dropCompleted', {accountID:12})
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)

    it "Should cancel for Texas Customers", ->
        createAccountSpy(fsm)
        fsm.raise('dropCompleted', {accountID:12, state:'TX'})
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)
        expect(fsm.current_state_name).toEqual('Cancel')

    it "Should send Letter for PA Customers", ->
        createAccountSpy(fsm,{ state:'PA','ECF':100})
        fsm.raise('dropCompleted', {accountID:12})
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)
        expect(fsm.current_state_name).toEqual('Success')

    it "Should cancel for PA customers with 0 ECF", ->
        createAccountSpy(fsm,{ state:'PA','ECF':0})
        fsm.raise('dropCompleted', {accountID:12})
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)
        expect(fsm.current_state_name).toEqual('Cancel')
fsmFactory = require('../src/type12').type12fsm

createAccountSpy = (fsm, data = {}) ->
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
        expect(fsm.state).toEqual("waiting")
        fsm.handle("dropCompleted", 12)
        expect(fsm.state).toNotEqual("waiting")
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)

describe "Eligibility", ->
    fsm = {}
    beforeEach ->
        fsm = fsmFactory()
    it "Should cancel for Texas Customers", ->
        createAccountSpy(fsm)
        fsm.handle("dropCompleted", 12)
        expect(fsm.state).toEqual("checkTX")        
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)
    it "Should pass to checkECF for nonTexas Customers", ->
        createAccountSpy(fsm,{state:'PA'})
        fsm.handle("dropCompleted", 12)
        expect(fsm.state).toEqual("checkECF")        
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)
    it "NonTexas Customers w ECF of 0 get cancelled", ->
        createAccountSpy(fsm,{state:'PA','ECF':0})
        fsm.handle("dropCompleted", 12)
        expect(fsm.state).toEqual("cancel")
        expect(fsm.AccountClient).toHaveBeenCalledWith(12)
        expect(fsm.AccountClient.callCount).toEqual(2)
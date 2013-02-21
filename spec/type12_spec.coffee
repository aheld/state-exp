fsm = require('../src/type12').type12fsm()

createAccountSpy = (data = {}) ->
    spyOn(fsm, 'AccountClient').andReturn(
        utility:
            state: data["state"] || "TX"
        )

describe "Basic state machine", ->
    it "Should transition", ->
        createAccountSpy()
        expect(fsm.state).toEqual("waiting")
        fsm.handle("dropCompleted")
        expect(fsm.state).toNotEqual("waiting")

describe "Eligibility", ->
    it "Should cancel for Texas Customers", ->
        createAccountSpy()
        fsm.transition("eligibility")
        expect(fsm.state).toEqual("checkTX")        
fsm = require('../src/type12').type12fsm()

describe "Basic state machine", ->
    it "Should transition", ->
        expect(fsm.state).toEqual("waiting")
        fsm.handle("dropCompleted")
        expect(fsm.state).toEqual("eligibility")
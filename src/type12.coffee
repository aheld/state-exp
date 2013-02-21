_ = require 'underscore'
machinaFactory = require 'machina'
machina = machinaFactory _

type12fsmFactory = ->
 new machina.Fsm
    initialState: "waiting"
    states :
        waiting :
            dropCompleted :-> 
                @.transition("eligibility")
        
        eligibility : 
            _onEnter : ->
                #check account

module.exports.type12fsm = type12fsmFactory
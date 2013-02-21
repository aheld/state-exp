_ = require 'underscore'
machinaFactory = require 'machina'
machina = machinaFactory _

type12fsmFactory = ->
    fsm = new machina.Fsm
        initialState: "waiting"
        states :
            waiting :
                dropCompleted :-> 
                    @.transition("eligibility")
            
            eligibility : 
                _onEnter : ->
                    @.transition("checkTX")

            checkTX : 
                _onEnter : ->
                    if (@.AccountClient(12).utility.state == "TX")
                        @.transition("Cancel", {state:"checkTX", msg:"Texas Customer"} )
                    else
                        @.transition("checkECF")

            cancel:
                _onEnter : ->
                    #
    fsm.AccountClient = ->
        console.log("OVERRIDE ME")

    fsm


module.exports.type12fsm = type12fsmFactory
_ = require 'underscore'
machinaFactory = require 'machina'
machina = machinaFactory _

type12fsmFactory = ->
    fsm = new machina.Fsm
        initialState: "waiting"
        states :
            waiting :
                dropCompleted : (accountID)-> 
                    @.transition("eligibility", accountID)
            
            eligibility : 
                _onEnter : (accountID) ->
                    @.transition("checkTX", accountID)

            checkTX : 
                _onEnter : (accountID) ->
                    if (@.AccountClient(accountID).utility.state == "TX")
                        @.transition("Cancel", {state:"checkTX", msg:"Texas Customer"} )
                    else
                        @.transition("checkECF", accountID)

            checkECF:
                _onEnter : (accountID) ->
                    if (@.AccountClient(accountID).pricing.current.ECF == 0)
                        @.transition("Cancel", {state:"checkECF", msg:"ECF = 0"} )
                    else
                        @.transition("checkECF")

            cancel:
                _onEnter : ->
                    #
    fsm.AccountClient = ->
        console.log("OVERRIDE ME")

    fsm


module.exports.type12fsm = type12fsmFactory
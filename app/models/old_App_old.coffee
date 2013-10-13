# app model
#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

  playerHit: ->
    @.get('playerHand').hit()
    if @bustCheck() is "newGame"
      @initialize()
      return
    if @.get('dealerHand').dealerScore()[1] && @.get('dealerHand').dealerScore()[1] < 17
      @.get('dealerHand').hit()
    else if @.get('dealerHand').dealerScore()[0] < 17
      @.get('dealerHand').hit()

  playerStand: ->
    @.get("dealerHand").models[0].flip()
    @.get("playerHand").stand = true
    if @.get("dealerHand").dealerScore()[1]
      while @.get("dealerHand").dealerScore()[1] < 17
        @.get("dealerHand").hit()
        if @.get("dealerHand").dealerScore().length < 2
          @.get("dealerHand").hit()  while @.get("dealerHand").dealerScore()[0] < 17
          break
    else
      @.get("dealerHand").hit()  while @.get("dealerHand").dealerScore()[0] < 17
    if @bustCheck() is "newGame"
      @initialize()



  flipit: =>
    !@.get('dealerHand').models[0].get('revealed') and @.get('dealerHand').models[0].flip()

  bustCheck: ->
    playerscore = @.get('playerHand').scores()[1] || @.get('playerHand').scores()[0]
    dealerscore = @.get('dealerHand').dealerScore()[1] || @.get('dealerHand').dealerScore()[0]
    if playerscore > 21
      @flipit()
      alert "player busted"
      if dealerscore > 21
        alert "dealer busted -- TIE"
        # Need to refactor this in new app.js -- if both player and dealer bust dealer wins in Blackjack rules.
        # So we know that if player ever busts player always loses no matter what
      else if dealerscore <= 21
        alert "dealer wins! You lose!"
      return "newGame"

    else if dealerscore > 21
      @flipit()
      alert "dealer busted"
      alert "player wins!!"
      return "newGame"

    else # if both under 21
      if @.get('playerHand').stand
        console.log("PLAYER IS STANDING")
        if playerscore < dealerscore
          alert "player loses"
        else if playerscore > dealerscore
          alert "you win!!!"
        else
          alert "TIE"
        console.log ('getting to a new game')
        return "newGame"


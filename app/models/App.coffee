# app model
#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'gameOver', undefined, {silent: true}
    @get('playerHand').on 'bust', @playerBust, @
    @get('dealerHand').on 'bust', @dealerBust, @

  playerBust: ->
    @get('dealerHand').flip()
    @get('dealerHand').playable = false
    @set 'gameOver', 'player busted'

  dealerBust: ->
    @get('playerHand').playable = false
    @get('dealerHand').flip()
    @set 'gameOver', 'dealer busted'

  playerHit: ->
    @get('playerHand').hit()
    @get('dealerHand').hit()
    #dealer has to hit too

  playerStand: ->
    @get('playerHand').playerStand()
    @get('dealerHand').playToWin()
    @bustCheck()

  bustCheck: ->
    playerscore = @get('playerHand').maxScore()
    dealerscore = @get('dealerHand').maxScore()
    if @get('playerHand').stand
      if playerscore < dealerscore
        @set 'gameOver', 'dealer wins'
      else if playerscore > dealerscore
        @set 'gameOver', 'player wins'
      else
        @set 'gameOver', 'tie - dealer wins'



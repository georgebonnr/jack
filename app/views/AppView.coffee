#view of model app
class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": "playerHit"
    "click .stand-button": "playerStand"

  initialize: -> @render()

  playerHit: ->
    @model.get('playerHand').hit()
    if @bustCheck() is "newGame"
      return
    if @model.get('dealerHand').dealerScore()[1] && @model.get('dealerHand').dealerScore()[1] < 17
      @model.get('dealerHand').hit()
    else if @model.get('dealerHand').dealerScore()[0] < 17
      @model.get('dealerHand').hit()

  playerStand: ->
    @model.get("dealerHand").models[0].flip()
    @model.get("playerHand").stand = true
    if @model.get("dealerHand").dealerScore()[1]
      while @model.get("dealerHand").dealerScore()[1] < 17
        @model.get("dealerHand").hit()
        if @model.get("dealerHand").dealerScore().length < 2
          @model.get("dealerHand").hit()  while @model.get("dealerHand").dealerScore()[0] < 17
          break
    else
      @model.get("dealerHand").hit()  while @model.get("dealerHand").dealerScore()[0] < 17
    @bustCheck()


  flipit: =>
    !@model.get('dealerHand').models[0].get('revealed') and @model.get('dealerHand').models[0].flip()

  bustCheck: ->
    playerscore = @model.get('playerHand').scores()[1] || @model.get('playerHand').scores()[0]
    dealerscore = @model.get('dealerHand').dealerScore()[1] || @model.get('dealerHand').dealerScore()[0]
    if playerscore > 21
      @flipit()
      alert "player busted"
      if dealerscore > 21
        alert "dealer busted -- TIE"
      else if dealerscore <= 21
        alert "dealer wins! You lose!"
      @model = new App()
      @render()
      return "newGame"

    else if dealerscore > 21
      @flipit()
      alert "dealer busted"
      alert "player wins!!"
      @model = new App()
      @render()
      return "newGame"

    else
      if @model.get('playerHand').stand
        if playerscore < dealerscore
          alert "player loses"
        else if playerscore > dealerscore
          alert "you win!!!"
        else
          alert "TIE"
        @model = new App()
        @render()
        return "newGame"

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

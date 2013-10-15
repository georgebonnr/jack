#view of model app
class window.AppView extends Backbone.View

  events:
    "click #hit-button": "playerHit"
    "click #stand-button": "playerStand"
    "click #replay": "replay"

  initialize: ->
    @model.on 'change:gameOver', =>
      @render()
    @render()


  playerHit: ->
    @model.playerHit()

  playerStand: ->
    @model.playerStand()

  replay: ->
    @model.initialize()
    @render()

  gameTemplate: _.template '<div class="alert"><%= gameOver %></div>'

  render: ->
    if @model.get('gameOver')
      controls = '<button id="hit-button" disabled>Hit</button> <button id="stand-button" disabled>Stand</button><button id="replay">New Game</button>'
    else
      controls = '<button id="hit-button">Hit</button> <button id="stand-button">Stand</button>'
    player = '<div class="player-hand-container"></div>'
    dealer = '<div class="dealer-hand-container"></div>'
    @$el.children().detach()
    @$el.append @gameTemplate @model.attributes
    @$el.append(controls,player,dealer)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.game-over').html

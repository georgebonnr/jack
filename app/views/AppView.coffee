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

  initialize: ->
    @model.on 'change:gameOver', =>
      alert @model.get('gameOver')
      @model.initialize()
      @render()
    @render()


  playerHit: ->
    @model.playerHit()

  playerStand: ->
    @model.playerStand()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

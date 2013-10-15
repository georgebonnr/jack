# collection of
class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    if @playable
      if @isDealer
        @dealerHit()
      else
        @add(@deck.pop()).last()
      @bustCheck()

  stand: false
  playable: true
  flipped: false

  dealerHit: ->
    if @maxScore() < 17
      @add(@deck.pop()).last()

  flip: ->
    if !@flipped
      @first().flip()
      @flipped = true

  playerStand: ->
    @playable = false
    @stand = true

  playToWin: ->
    @flip()
    setTimeout(play = (=>
      if @maxScore() < 17
        @add(@deck.pop()).last()
        setTimeout(play, 1000)
      else 
        if @maxScore() > 21 
          @trigger 'bust' 
        else @trigger 'check'
      ), 1000)


  scores: ->
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce
      if score + 10 > 21
      then [score]
      else [score, score + 10]
    else [score]

  dealerScore: ->
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + card.get 'value'
    , 0
    if hasAce
      if score + 10 > 21
      then [score]
      else [score, score + 10]
    else [score]

  maxScore: ->
    if @isDealer
      return @dealerScore()[1] || @dealerScore()[0]
    else
      return @scores()[1] || @scores()[0]

  bustCheck: ->
    if @maxScore() > 21
      @playable = false
      @trigger 'bust'
      'bust'
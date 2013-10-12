# describe "HandView", ->
  it "should render on changes to the collection", ->
    deck = new Deck()
    hand = deck.dealPlayer()
    handview = new HandView(collection: hand)
    expect(handview.render).toHaveBeenCalled()
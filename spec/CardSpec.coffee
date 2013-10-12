describe "deck constructor", ->

  it "should create a card collection", ->
    collection = new Deck()
    expect(collection.length).toBe 52

  it "should have a dealPlayer property", ->
    collection = new Deck()
    expect(collection.dealPlayer).toBeDefined()
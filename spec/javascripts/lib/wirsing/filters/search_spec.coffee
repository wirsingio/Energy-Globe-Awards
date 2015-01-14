
{search} = wirsing.filter

describe 'wirsing.filter.search', ->

  beforeEach ->
    @items = [
      {name: 'Dominik from Vienna', city: 'Vienna'},
      {name: 'Clemens', city: 'Vienna'},
      {name: 'Aaron', city: 'Klosterneuburg'}
    ]

  it 'allows to search for a term in specified property', ->
    filter = search term: 'Dominik', in: 'name'
    expect(filter @items).toEqual [@items[0]]

  it 'ignores case while searching', ->
    filter = search term: 'doMiniK', in: 'name'
    expect(filter @items).toEqual [@items[0]]

  # ============ SEARCH TERM ============= #

  describe 'configuring search term', ->

    beforeEach -> @filter = search in: 'name'

    it 'is empty by default', -> expect(@filter.term).toEqual ''

    it 'can be changed after creation', ->
      @filter.configure term: 'Dominik'
      expect(@filter.term).toEqual 'Dominik'
      expect(@filter @items).toEqual [@items[0]]

    it 'sanitizes the given search term', ->
      @filter.configure term: 'Dom]in\i&k/'
      expect(@filter.term).toEqual 'Dominik'
      
  # ============ SEARCH PROPERTY ============= #

  describe 'property to search in', ->

    it 'is required on creation', ->
      expect(-> search term: 'Vienna').toThrow()

    it 'can be any property', ->
      filter = search term: 'Vienna', in: 'city'
      expect(filter @items).toEqual [@items[0], @items[1]]

    it 'can be changed after creation', ->
      filter = search term: 'Vienna', in: 'city'
      filter.configure in: 'name'
      expect(filter @items).toEqual [@items[0]]

  # ============ MINIMUM CHARACTERS ============= #

  describe 'minimum characters in search term', ->

    beforeEach -> @filter = search in: 'name'

    it 'does not filter if less characters given', ->
      @filter.configure term: 'Do'
      expect(@filter @items).toEqual @items

    it 'has a sane default value', ->
      @filter.configure term: 'Dom'
      expect(@filter @items).toEqual [@items[0]]
      expect(@filter.minChars).toEqual 3

    it 'can be changed after creation', ->
      @filter.configure term: 'Dom', minChars: 5
      expect(@filter @items).toEqual @items
      expect(@filter.minChars).toEqual 5


{search} = wirsing.filter

describe 'wirsing.filter.search', ->

  beforeEach ->
    @items = [
      {name: 'Dominik from Vienna', city: 'Vienna'},
      {name: 'Clemens [DönerDöner Kebab]', city: 'Vienna'},
      {name: 'Aaron', city: 'Klosterneuburg'},
      {name: 'Vienna', city: 'Dominik'},
      {name: 'Hyph&shy;ens can be any&shy;where', city: 'Hyphen City'},
    ]

  it 'allows to search for a term in specified property', ->
    filter = search term: 'Dominik', in: 'name'
    expect(filter @items).toEqual [@items[0]]

  it 'ignores case while searching', ->
    filter = search term: 'doMiniK', in: 'name'
    expect(filter @items).toEqual [@items[0]]

  it 'also works with umlauts', ->
    filter = search term: 'Döner Kebab', in: 'name'
    expect(filter @items).toEqual [@items[1]]

  it 'supports regexp expressions in search term', ->
    filter = search term: '(Döner){2} Kebab', in: 'name'
    expect(filter @items).toEqual [@items[1]]

  it 'deals with hyphenated text correctly', ->
    filter = search term: 'Hyphens can be anywhere', in: 'name'
    expect(filter @items).toEqual [@items[4]]

  # ============ SEARCH TERM ============= #

  describe 'configuring search term', ->

    beforeEach -> @filter = search in: 'name'

    it 'is empty by default', -> expect(@filter.term).toEqual ''

    it 'can be changed after creation', ->
      @filter.configure term: 'Dominik'
      expect(@filter.term).toEqual 'Dominik'
      expect(@filter @items).toEqual [@items[0]]

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
      expect(filter @items).toEqual [@items[0], @items[3]]

    it 'can also be multiple', ->
      filter = search term: 'Vienna', in: ['city', 'name']
      expect(filter @items).toEqual [@items[0], @items[1], @items[3]]

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

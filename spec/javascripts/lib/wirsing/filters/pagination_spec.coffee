describe 'wirsing.filter.pagination', ->
  beforeEach ->
    @data = [0..100]
    @length = 10
    @paginate = wirsing.filter.pagination perPage: @length

  it 'initializes to the correct size', ->
    expect(@paginate(@data)).toEqual [0...@length]

  it 'can page to the next page', ->
    @paginate.nextPage()
    expect(@paginate(@data)).toEqual [0...@length * 2]

  it 'only resets the size after paging to the first page', ->
    @paginate.nextPage()
    @paginate.firstPage()
    expect(@paginate(@data)).toEqual [0...@length]


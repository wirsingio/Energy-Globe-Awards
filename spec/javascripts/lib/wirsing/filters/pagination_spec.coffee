describe 'wirsing.filter.pagination', ->
  beforeEach ->
    @data = [0..100]
    @length = 10
    @paginate = wirsing.filter.pagination perPage: @length

  it 'initializes to the correct size', ->
    expect(@paginate(@data).length).toEqual(@length)

  it 'can page to the next page', ->
    expect(@paginate(@data)).not.toContain(15)
    @paginate.nextPage()
    expect(@paginate(@data)).toContain(15)

  it 'has the correct amount of items after paging', ->
    @paginate.nextPage()
    expect(@paginate(@data).length).toEqual(@length * 2)

  it 'only resets the size after paging to the first page', ->
    @paginate.nextPage()
    @paginate.firstPage()
    expect(@paginate(@data).length).toEqual(@length)


describe 'wirsing.utils.Pager', ->
  beforeEach ->
    data = [0..100]
    @length = 10
    @pList = new wirsing.utils.Pager(perPage: @length)
    @pList.setList(data)

  it 'initializes to the correct size', ->
    expect(@pList.currentList().length).toEqual(@length)

  it 'can page to the next page', ->
    expect(@pList.currentList()).not.toContain(15)
    @pList.nextPage()
    expect(@pList.currentList()).toContain(15)

  it 'has the correct amount of items after paging', ->
    @pList.nextPage()
    expect(@pList.currentList().length).toEqual(@length * 2)

  it 'resets list size when you add new items', ->
    @pList.nextPage()
    newData = [0..100]
    @pList.setList(newData)
    expect(@pList.currentList().length).toEqual(@length)


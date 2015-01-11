describe 'wirsing.utils.Pager', ->

  it 'initializes to the correct size', ->
    data = [0..100]
    length = 10
    pList = new wirsing.utils.Pager(perPage: length)
    pList.setList(data)
    expect(pList.currentList().length).toEqual(length)


  it 'grows as expected', ->
    data = [0..100]
    length = 10
    pList = new wirsing.utils.Pager(perPage: length)
    pList.setList(data)
    expect(pList.currentList()).not.toContain(15)
    pList.nextPage(data)
    expect(pList.currentList()).toContain(15)

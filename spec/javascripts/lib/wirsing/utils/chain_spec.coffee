describe 'wirsing.utils.chain', ->

  it 'calls all functions in the order that they are passed to it', ->
    
    firstFilter = (items) -> [items[0]]
    largerThanOneFilter = (items) -> item for item in items when item > 1
    filter = wirsing.utils.chain [largerThanOneFilter, firstFilter]

    filterResult = filter [1, 2, 3]

    expect(filterResult).toEqual [2]

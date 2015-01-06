describe 'wirsing.filters.chain', ->
  it "calls a filter that's passed to it", ->
    firstFilter = (items) -> [items[0]]
    filter = wirsing.filter.chain [firstFilter]

    filterResult = filter [1, 2, 3]

    expect(filterResult).toEqual [1]

  it 'calls all filters in the order that they are passed to it', ->
    firstFilter = (items) -> [items[0]]
    largerThanOneFilter = (items) -> item for item in items when item > 1
    filter = wirsing.filter.chain [largerThanOneFilter, firstFilter]

    filterResult = filter [1, 2, 3]

    expect(filterResult).toEqual [2]

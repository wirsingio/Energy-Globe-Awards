describe 'wirsing.filter.helper', ->
  beforeEach ->
    @items = [
      {name: 'Dominik', city: 'Vienna'},
      {name: 'Clemens', city: 'Vienna'},
      {name: 'Aaron', city: 'Klosterneuburg'}
    ]

  it 'extracts the available keys', ->
    expect wirsing.filter.helper.keys(@items, 'city')
      .toEqual ['Vienna', 'Klosterneuburg']

  it 'generates a configuration to show all switches', ->
    expect wirsing.filter.helper.trueMap ['Vienna', 'Klosterneuburg']
      .toEqual {'Vienna': true, 'Klosterneuburg': true}

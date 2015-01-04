describe 'wirsing.filter.switch', ->
  beforeEach ->
    items = [
      {name: 'Dominik', city: 'Vienna'},
      {name: 'Clemens', city: 'Vienna'},
      {name: 'Aaron', city: 'Klosterneuburg'}
    ]

    @filter = wirsing.filter.switch.on(items, 'city')

  it 'extracts the available switches', ->
    expect @filter.names()
      .toEqual ['Vienna', 'Klosterneuburg']

  it 'generates a configuration to show all switches', ->
    expect @filter.allShown()
      .toEqual {'Vienna': true, 'Klosterneuburg': true}

  it 'filters by applying a configuration on the filter', ->
    expect @filter.apply('Vienna': false, 'Klosterneuburg': true)
      .toEqual [{name: 'Aaron', city: 'Klosterneuburg'}]

describe 'wirsing.filter.switch', ->
  beforeEach ->
    @items = [
      {name: 'Dominik', city: 'Vienna'},
      {name: 'Clemens', city: 'Vienna'},
      {name: 'Aaron', city: 'Klosterneuburg'}
    ]

    @filter = wirsing.filter.switch.on('city')

  it 'filters by applying a configuration on the filter', ->
    @filter.apply 'Vienna': false, 'Klosterneuburg': true
    expect @filter(@items)
      .toEqual [{name: 'Aaron', city: 'Klosterneuburg'}]

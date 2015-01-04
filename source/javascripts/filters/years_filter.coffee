EGA.filter 'yearsFilter', ->
  (items, switches) ->
    wirsing.filter['switch'].on(items, 'year').apply switches

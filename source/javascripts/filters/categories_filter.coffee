EGA.filter 'categoriesFilter', ->
  (items, switches) ->
    wirsing.filter['switch'].on(items, 'category').apply switches

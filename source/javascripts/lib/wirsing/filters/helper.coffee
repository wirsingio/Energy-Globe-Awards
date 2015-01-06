#= require ../module

wirsing.module 'filter.helper', ->
  trueMap: (keys) ->
    map = {}
    map[key] = true for key in keys
    map

  keys: (items, key) ->
    map = {}
    map[item[key]] ?= true for item in items
    Object.keys(map)

  chain: (functions) -> return -> fn() for fn in functions

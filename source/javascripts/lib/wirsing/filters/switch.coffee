#= require ../module

wirsing.module 'filter.switch', ->
  on: (items, key) ->
    switchObject = {}

    switches = ->
      if Object.keys(switchObject).length == 0
        switchObject[item[key]] ?= true for item in items
      switchObject

    names: -> Object.keys switches()

    allShown: -> switches()

    apply: (isShown) -> item for item in items when isShown[item[key]]

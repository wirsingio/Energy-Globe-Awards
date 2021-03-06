#= require ../module

wirsing.module 'filter.choices', ->
  on: (key) ->
    shownMap = {}
    filter = (items) -> item for item in items when shownMap[item[key]]
    filter.configure = (isShown) -> shownMap = isShown

    filter

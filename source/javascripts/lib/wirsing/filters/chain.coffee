#= require ../module

wirsing.module 'filter.chain', ->
  (filters) ->
    (items) ->
      for filter in filters
        items = filter(items)
      items

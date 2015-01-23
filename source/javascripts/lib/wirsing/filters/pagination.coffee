#= require ../module

wirsing.module 'filter.pagination', ->
  (options) ->
    pageSize = options.perPage ? 30
    visibleCount = 0

    filter = (items) -> items[...visibleCount]

    filter.nextPage = -> visibleCount += pageSize

    filter.firstPage = -> visibleCount = pageSize

    filter.firstPage()

    return filter

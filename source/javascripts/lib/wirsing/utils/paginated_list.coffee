#= require ../module

# creates a list that makes paginating a list simple

wirsing.module 'utils.PaginatedList', ->
  class PaginatedList
    constructor: (@options) ->
      @pageSize     = @options.pageSize || 30
      @list         = []
      @visibleCount = @pageSize

    setList: (newList) -> @list = newList
    nextPage:    -> @visibleCount += @pageSize
    currentList: -> @list.slice(0,@visibleCount)

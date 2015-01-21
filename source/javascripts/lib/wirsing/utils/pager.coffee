#= require ../module

# creates a list that makes paginating a list simple

wirsing.module 'utils.Pager', ->
  class Pager
    constructor: (@options={}) ->
      @pageSize = @options.perPage || 30
      @list     = []
      @resetCount()

    resetCount: -> @visibleCount = @pageSize

    setList: (newList) ->
      @list = newList
      @resetCount()

    nextPage:    -> @visibleCount += @pageSize

    currentList: -> @list.slice(0,@visibleCount)

#= require ../module

# Returns a configurable search function that can be used
# to filter an array of objects by searching for a term
# within the specified property of each object.

wirsing.module 'filter.search', ->

  (options) ->

    search = (items) ->
      if search.term.length < search.minChars then return items
      else items.filter (item) -> item[search.in].search(search.term) > -1

    search.configure = (config) ->
      search.in = config.in || search.in || throw new Error 'option: <in> required'
      search.term = config.term || search.term || ''
      search.minChars = config.minChars || search.minChars || 3
      return search

    search.configure(options)

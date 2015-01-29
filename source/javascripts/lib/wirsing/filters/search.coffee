#= require ../module

wirsing.module 'filter.search', ->

  # Returns a configurable search function that can be used
  # to filter an array of objects by searching for a term
  # within the specified property of each object.

  (options) ->

    # This is the function that is returned to the outside world.
    # It takes an array of objects and returns an array of matching objects
    search = (items) ->
      if search.term.length < search.minChars
        items # dont filter
      else
        items.filter (item) -> search.in.some (key) ->
          text = removeHyphens item[key]
          isMatchingSearchTerm text, search.term

    # Makes the search function completely configurable from outside
    search.configure = (config) ->
      keys = config.in ? search.in ? throw new Error 'option: <in> required'
      search.in = [].concat keys # ensure its always an array
      search.term = config.term ? search.term ? ''
      search.minChars = config.minChars ? search.minChars ? 3

    # Configure the created search function before returning it
    search.configure options
    return search

# --------- Private helpers -----------

removeHyphens = (text) -> text.replace /\&shy\;/gi, ''

isMatchingSearchTerm = (text, searchTerm) ->
  text.toLowerCase().search(searchTerm.toLowerCase()) > -1

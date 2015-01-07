#= require ../module

# Takes an arry of functions and returns a chain function.
# When invoked it calls all given functions in a row, while
# using the output of each as input of the next.

wirsing.module 'utils.chain', ->

  (functions) ->

    return -> # chain function

      # Start with the input to the chain
      input = arguments

      # Use the output of the previous function for the next input
      input = [fn.apply(null, input)] for fn in functions

      # unwrap final output
      return input[0]

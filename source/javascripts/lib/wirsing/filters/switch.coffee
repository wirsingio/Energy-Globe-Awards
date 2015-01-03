@wirsing ?= {}
wirsing.filter ?= {}

wirsing.filter.switch =
  on: (items, key) ->
    switches = {}

    for item in items
      switches[item[key]] ?= true

    availableSwitches: -> Object.keys(switches)

    allShown: -> switches

    apply: (isShown) -> item for item in items when isShown[item[key]]

@wirsing ?= {}
wirsing.module = (name, moduleFunction) ->
  [predecessors..., component] = name.split('.')
  module = wirsing

  for predecessor in predecessors
    module[predecessor] ?= {}
    module = module[predecessor]

  module[component] = if moduleFunction? then moduleFunction() else {}

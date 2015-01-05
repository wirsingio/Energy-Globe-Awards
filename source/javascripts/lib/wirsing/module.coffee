@wirsing ?= {}
wirsing.module = (name, properties = {}) ->
  components = name.split('.')
  module = wirsing

  for component in components
    module[component] ?= {}
    module = module[component]

  module[property] = value for property, value of properties

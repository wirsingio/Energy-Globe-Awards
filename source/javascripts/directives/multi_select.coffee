
# Multi-select directive, liberally taken and modified from
# https://github.com/rayshan/ui-multiselect

EGA.directive 'multiSelect', ->

  KEY_CODES = 38: 'up', 40: 'down', 8: 'backspace', 13: 'enter', 9: 'tab', 27: 'esc'

  return {
    templateUrl: 'multi_select.html',

    # Two-way bind html element attributes to directive scope
    scope: {
      options: '=', # The options attribute is bound to scope.options
      selected: '=' # The selected attribute is bound to scope.selected
    },

    link: (scope, element, attrs) ->

      # Setup private directive scope
      scope.query = ''
      scope.focusInput = false
      scope.hoverSelector = false
      scope.showSelector = false
      scope.focusChoice = []

      # define defaults for configuration
      attrs.placeholder ?= ''

      element.addClass 'multi-select'

      updatePlaceholder = (selected) ->
        scope.placeholder = if !selected.length then attrs.placeholder else ''

      calculateInputBoxWidth = (query) ->
        length = scope.placeholder.length
        if query.length > 0 then length = query.length
        scope.inputWidth = 10 + length * 10

      ensureSelectorVisibility = (focusOrHover) ->
        # selector popup should still show if input is focused, even if not hovered
        scope.showSelector = focusOrHover.some (element) -> element

      scope.addItem = (item) -> scope.selected.push(item) and scope.query = []

      scope.removeItem = (position) -> scope.selected.splice position, 1

      scope.focus = ->
        scope.focusInput = true
        scope.selectorPosition = 0

      scope.blur = -> scope.focusInput = false

      scope.$watch 'selected', updatePlaceholder, true
      scope.$watch 'query', calculateInputBoxWidth
      scope.$watch '[focusInput, hoverSelector]', ensureSelectorVisibility, true

      scope.keyParser = ($event) ->

        key = KEY_CODES[$event.keyCode]
        queryIsEmpty = scope.query.length == 0

        # backspace should work when query isn't empty
        if !key or (key is 'backspace' and !queryIsEmpty)
          scope.selectorPosition = 0
        else
          atTop = scope.selectorPosition is 0
          atBottom = scope.selectorPosition is scope.filteredData.length - 1
          choiceFocused = scope.focusChoice[scope.selected.length - 1] is true
          filteredDataExists = scope.filteredData.length > 0

          if key is 'up'

            if atTop or !scope.selectorPosition
              scope.selectorPosition = scope.filteredData.length - 1
            else
              scope.selectorPosition--

          if key is 'down'
            if atBottom then scope.selectorPosition = 0 else scope.selectorPosition++

          if key is 'backspace'
            if choiceFocused
              scope.removeItem scope.selected.length - 1
              scope.focusChoice = []
            else
              scope.focusChoice[scope.selected.length - 1] = true

          if (key is 'enter') or (key is 'tab') and filteredDataExists
            scope.addItem scope.filteredData[scope.selectorPosition], scope.selected.length

          if (key is 'esc') and scope.focusChoice? then scope.focusChoice = []

          $event.preventDefault()
  }

EGA.directive 'imageSuggestions', ->
  restrict: 'A'
  scope:
    imageSuggestions: '='
  link: (scope, element, attrs) ->
    scope.$watch 'imageSuggestions', (images) ->
      loadImage = (index = 0) ->
        return if index >= images.length

        imageObj = new Image
        imageObj.onload = -> element.prepend(imageObj)
        imageObj.onerror = -> loadImage(index + 1)
        imageObj.src = images[index]

      loadImage()

isBroken = {}

EGA.directive 'awardHeader', ->
  restrict: 'E'
  scope:
    award: '='
  transclude: true
  replace: true
  template: "<header ng-transclude></header>"
  link: (scope, element, attrs) ->
    images = scope.award.images

    loadImage = (index = 0) ->
      return if index >= images.length

      imageUrl = images[index]
      if isBroken[imageUrl]
        loadImage(index + 1)
        return

      imageObj = new Image
      imageObj.onload = -> element.prepend(this)
      imageObj.onerror = ->
        isBroken[@src] = true
        loadImage(index + 1)
      imageObj.src = imageUrl

    loadImage()

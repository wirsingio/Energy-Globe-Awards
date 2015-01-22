EGA.directive 'awardHeader', ->
  restrict: 'E'
  scope:
    award: '='
  transclude: true
  replace: true
  template: "<header ng-transclude></header>"
  link: (scope, element, attrs) ->
    scope.$watch 'award', (award) ->
      images = award.images

      loadImage = (index = 0) ->
        return if index >= images.length

        imageObj = new Image
        imageObj.onload = -> element.prepend(imageObj)
        imageObj.onerror = -> loadImage(index + 1)
        imageObj.src = images[index]

      loadImage()

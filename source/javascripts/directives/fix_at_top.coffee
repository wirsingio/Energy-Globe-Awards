EGA.directive 'fixAtTop', ($window) ->
  {
    restrict: 'A',
    link: (scope, element, attributes) ->
      elementOffset = element[0].getBoundingClientRect().top

      angular.element($window).on 'scroll', ->
        isFixed = $window.pageYOffset >= elementOffset
        element.toggleClass('is-fixed', isFixed)
  }

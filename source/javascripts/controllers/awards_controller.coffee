EGA.controller "AwardsController", ($scope, $http) ->
  $scope.awards = []
  $scope.categories = []
  $scope.categoryIsShown = {}
  $scope.years = []
  $scope.yearIsShown = {}

  categoriesFilter = wirsing.filter.switch.on('category')
  yearsFilter = wirsing.filter.switch.on('year')
  filter = wirsing.filter.chain(categoriesFilter, yearsFilter)

  $scope.filteredAwards = []

  $scope.$watch 'categoryIsShown', (switches) ->
    categoriesFilter.apply switches
    $scope.filteredAwards = filter($scope.awards)
  , true

  $scope.$watch 'yearIsShown', (switches) ->
    yearsFilter.apply switches
    $scope.filteredAwards = filter($scope.awards)
  , true

  $http.get("data/awards.json").then (res) ->
    $scope.awards = res.data

    $scope.categories = wirsing.filter.helper.keys($scope.awards, 'category')
    $scope.categoryIsShown = wirsing.filter.helper.trueMap($scope.categories)

    $scope.years = wirsing.filter.helper.keys($scope.awards, 'year').sort()
    $scope.yearIsShown = wirsing.filter.helper.trueMap($scope.years)

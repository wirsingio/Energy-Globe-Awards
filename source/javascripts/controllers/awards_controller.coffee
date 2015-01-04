EGA.controller "AwardsController", ($scope, $http) ->
  $scope.awards = []
  $scope.categories = []
  $scope.categoryIsShown = {}

  $http.get("data/awards.json").then (res) ->
    $scope.awards = res.data

    categoriesFilter = wirsing.filter['switch'].on($scope.awards, 'category')
    $scope.categories = categoriesFilter.names()
    $scope.categoryIsShown = categoriesFilter.allShown()

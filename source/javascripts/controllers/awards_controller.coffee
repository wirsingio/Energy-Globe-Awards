EGA.controller "AwardsController", ($scope, $http) ->
  $scope.awards = []
  $scope.filters = {}

  {choices, chain, helper} = wirsing.filter

  choicesFilterNames = ['category', 'year']

  # set up scope
  for filterName in choicesFilterNames
    $scope.filters[filterName] =
      names: []
      filterMap: {}

  $scope.filteredAwards = []

  $scope.$watch 'filters', ->
    $scope.filteredAwards = filter($scope.awards)
  , true

  # set up filters
  choicesFilterMap = {}
  choicesFilterMap[name] = choices.on(name) for name in choicesFilterNames
  choicesFilters = (filter for name, filter of choicesFilterMap)
  filter = chain choicesFilters

  # fetch awards
  $http.get("data/awards.json").then (res) ->
    $scope.awards = res.data

    for filterName in choicesFilterNames
      filterConfig = $scope.filters[filterName]
      filterConfig.names = helper.keys($scope.awards, filterName).sort()
      filterConfig.filterMap = helper.trueMap(filterConfig.names)
      choicesFilterMap[filterName].apply filterConfig.filterMap

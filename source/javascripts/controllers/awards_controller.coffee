
{helper} = wirsing.filter

EGA.controller "AwardsController", ($scope, $http, filterPipeline) ->

  # setup view scope
  $scope.awards = []
  $scope.filteredAwards = []
  $scope.filters =
    category: names: [], filterMap: {}
    year: names: [], filterMap: {}

  configurePipeline = ->
    filterPipeline.setCategoryChoices $scope.filters.category.filterMap
    filterPipeline.setYearChoices $scope.filters.year.filterMap

  filterAwards = -> $scope.filteredAwards = filterPipeline.filter $scope.awards

  initializeFilters = ->
    for type of $scope.filters
      $scope.filters[type].names = helper.keys($scope.awards, type).sort()
      $scope.filters[type].filterMap = helper.trueMap($scope.filters[type].names)

  # react to changes of the original collection
  $scope.$watch 'awards', helper.chain [initializeFilters, filterAwards]

  # react to changes of filter configurations
  $scope.$watch 'filters', helper.chain([configurePipeline, filterAwards]), true

  # fetch awards
  $http.get("data/awards.json").then (result) -> $scope.awards = result.data


{filter, utils} = wirsing

EGA.controller "AwardsController", ($scope, $http, filterPipeline) ->

  # setup view scope
  $scope.awards = []
  $scope.filteredAwards = new utils.PaginatedList(pageSize: 30)
  $scope.filters =
    category: names: [], filterMap: {}
    year:     names: [], filterMap: {}

  configurePipeline = ->
    filterPipeline.setCategoryChoices $scope.filters.category.filterMap
    filterPipeline.setYearChoices $scope.filters.year.filterMap

  filterAwards = -> $scope.filteredAwards.setList(filterPipeline.filter($scope.awards))

  initializeFilters = ->
    for type of $scope.filters
      $scope.filters[type].names = filter.helper.keys($scope.awards, type).sort()
      $scope.filters[type].filterMap = filter.helper.trueMap($scope.filters[type].names)

  # paging function
  $scope.loadNextPage = -> $scope.filteredAwards.nextPage()

  # react to changes of the original collection
  $scope.$watch 'awards', utils.chain([initializeFilters, filterAwards])

  # react to changes of filter configurations
  $scope.$watch 'filters', utils.chain([configurePipeline, filterAwards]), true

  # fetch awards
  $http.get("data/awards.json").then (result) -> $scope.awards = result.data

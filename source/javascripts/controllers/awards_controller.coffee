
{filter, utils} = wirsing

EGA.controller "AwardsController", ($scope, $http, filterPipeline) ->

  # setup view scope
  $scope.awards = []
  $scope.filteredAwards = []
  $scope.filters =
    category:  names: [], filterMap: {}
    year:      names: [], filterMap: {}
    countries: names: [], selected: null
    searchTerm: ''

  configurePipeline = ->
    filterPipeline.setCategoryChoices $scope.filters.category.filterMap
    filterPipeline.setYearChoices $scope.filters.year.filterMap
    filterPipeline.setSearchTerm $scope.filters.searchTerm
    filterPipeline.setCountryChoices filter.helper.trueMap(getShownCountries())

  getShownCountries = ->
    if not $scope.filters.countries.selected?
      $scope.filters.countries.names # show all
    else
      [$scope.filters.countries.selected] # show the selected one

  filterAwards = -> $scope.filteredAwards = filterPipeline.filterFirstPage($scope.awards)

  initializeFilters = ->
    for type in ['category', 'year']
      $scope.filters[type].names = filter.helper.keys($scope.awards, type).sort()
      $scope.filters[type].filterMap = filter.helper.trueMap($scope.filters[type].names)

    $scope.filters.countries.names = filter.helper.keys($scope.awards, 'country').sort()

  # paging function
  $scope.loadNextPage = -> $scope.filteredAwards = filterPipeline.filterNextPage($scope.awards)

  # react to changes of the original collection
  $scope.$watch 'awards', utils.chain([initializeFilters, filterAwards])

  # react to changes of filter configurations
  $scope.$watch 'filters', utils.chain([configurePipeline, filterAwards]), true

  # fetch awards
  $http.get("data/awards.json").then (result) -> $scope.awards = result.data

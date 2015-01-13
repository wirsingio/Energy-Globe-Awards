
{filter, utils} = wirsing

EGA.controller "AwardsController", ($scope, $http, filterPipeline) ->

  # setup view scope
  $scope.awards = []
  $scope.filteredAwards = []
  $scope.filters =
    category: names: [], filterMap: {}
    year: names: [], filterMap: {}
    countries: names: [], selected: []
    search: ''

  configurePipeline = ->
    filterPipeline.setCategoryChoices $scope.filters.category.filterMap
    filterPipeline.setYearChoices $scope.filters.year.filterMap
    filterPipeline.setSearch $scope.filters.search
    
    {countries} = $scope.filters
    shownCountries = if anyCountriesSelected() then countries.selected else countries.names
    filterPipeline.setCountryChoices filter.helper.trueMap(shownCountries)

  anyCountriesSelected = -> $scope.filters.countries.selected.length > 0

  filterAwards = -> $scope.filteredAwards = filterPipeline.filter $scope.awards

  initializeFilters = ->
    for type in ['category', 'year']
      $scope.filters[type].names = filter.helper.keys($scope.awards, type).sort()
      $scope.filters[type].filterMap = filter.helper.trueMap($scope.filters[type].names)

    $scope.filters.countries.names = filter.helper.keys($scope.awards, 'country').sort()

  # react to changes of the original collection
  $scope.$watch 'awards', utils.chain([initializeFilters, filterAwards])

  # react to changes of filter configurations
  $scope.$watch 'filters', utils.chain([configurePipeline, filterAwards]), true

  # fetch awards
  $http.get("data/awards.json").then (result) -> $scope.awards = result.data

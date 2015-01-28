{filter, utils} = wirsing

EGA.controller "AwardsController", ($scope, $http, $sce, $window, filterPipeline) ->

  # setup view scope
  $scope.preloadAwards = (awards) -> $scope.awards = awards

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
    {countries} = $scope.filters
    if countries.selected? then [countries.selected] else countries.names

  filterAwards = ->
    $scope.filteredAwards = if $scope.awards then filterPipeline.filterFirstPage($scope.awards) else []

  initializeFilters = ->
    if $scope.awards
      $scope.filters.year.names = filter.helper.keys($scope.awards,'year').sort().reverse()
      $scope.filters.category.names = ['earth', 'water', 'fire', 'air', 'youth', 'other']

      for type in ['category', 'year']
        $scope.filters[type].filterMap = filter.helper.trueMap($scope.filters[type].names)

      $scope.filters.countries.names = filter.helper.keys($scope.awards, 'country').sort()

  # paging function
  $scope.loadNextPage = -> $scope.filteredAwards = filterPipeline.filterNextPage($scope.awards)

  # react to changes of the original collection
  $scope.$watch 'awards', utils.chain([initializeFilters, filterAwards])

  # react to changes of filter configurations
  $scope.$watch 'filters', utils.chain([configurePipeline, filterAwards]), true

  # make &shy; html safe
  $scope.sanitizeHTML = (text) -> $sce.trustAsHtml(text)

  # fetch awards
  $http.get("data/awards.json").then (result) -> $scope.awards = result.data

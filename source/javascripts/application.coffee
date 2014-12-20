
# main angular module
EGA = angular.module "ega", []

EGA.controller "AwardsController", ($scope, $http) ->
    
  $http.get("data/awards.json").then (res) -> $scope.awards = res.data
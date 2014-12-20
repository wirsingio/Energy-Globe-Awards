angular.module("ega", [])

angular.module("ega")
  .controller("AwardsController", ($scope, $http) ->
    $http.get("data/awards.json").then((res) ->
      $scope.awards = res.data
    )
  )

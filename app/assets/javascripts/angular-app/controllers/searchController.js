angular.module('vin.controllers').controller('SearchController', ['$scope', '$location', '$http', function($scope, $location, $http) {
  $scope.vin = "";
  $scope.typeahead_cache = {};

  $scope.vinTypeahead = function(val)
  {
    if($scope.typeahead_cache[val])
      return $scope.typeahead_cache[val];
    return $http.get("/vehicles/typeahead_vin/" + val).then(function(response){
      $scope.typeahead_cache[val] = response.data;
      return response.data;
    });
  };

  $scope.submitVin = function()
  {
    $location.path("/vehicles/by_vin/" + $scope.vin);
  };
}]);

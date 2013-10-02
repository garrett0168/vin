vinApp.controller('VehicleSearchController', ['$scope', '$location', '$http', function($scope, $location, $http) {
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

vinApp.controller('VehicleByVinController', ['$scope', '$routeParams', 'Vehicle', function($scope, $routeParams, Vehicle) {
  $scope.vehicle = Vehicle.get({vin: $routeParams.vin}, 
    function(response) 
    {
    }, 
    function(response) 
    {
      $scope.vehicle = null;
    });
}]);

vinApp.controller('VehiclesIndexController', ['$scope', 'Vehicles', function($scope, Vehicles) {
  $scope.totalVehicles = 0;
  $scope.currentPage = 1;
  $scope.vehiclesPerPage = 5;
  $scope.vehicles = Vehicles.query(function() {
    $scope.totalVehicles = $scope.vehicles.length;
  });
  $scope.vehiclesFiltered = [];

  $scope.$watch('currentPage', function() {
    $scope.filter();
  });

  $scope.$watch('totalVehicles', function() {
    $scope.filter();
  });

  $scope.filter = function()
  {
    var offset = ($scope.currentPage - 1) * $scope.vehiclesPerPage;
    $scope.vehiclesFiltered = $scope.vehicles.slice( offset, offset+$scope.vehiclesPerPage );
  };
}]);


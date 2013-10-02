vinApp.controller('VehicleSearchController', ['$scope', '$location', function($scope, $location) {
  $scope.vin = "";

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
  $scope.vehicles = Vehicles.query();
}]);

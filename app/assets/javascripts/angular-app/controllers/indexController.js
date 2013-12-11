angular.module('vin.controllers').controller('IndexController', ['$scope', 'Vehicles', function($scope, Vehicles) {
  $scope.totalVehicles = 0;
  $scope.currentPage = 1;
  $scope.vehiclesPerPage = 5;
  $scope.vehicles = [];

  $scope.$watch('currentPage', function(newVal, oldVal) {
    if(newVal != oldVal)
    {
      $scope.getVehicles();
    }
  });

  $scope.getVehicles = function()
  {
    $scope.searching = true;
    var result = Vehicles.get($scope.currentPage, $scope.vehiclesPerPage);
    result.then(handleGetVehiclesSuccess, handleGetVehiclesFailure).finally(getVehiclesComplete);
  };

  function handleGetVehiclesFailure(response)
  {
    $scope.vehicles = [];
    $scope.errors = response.data.message;
  };

  function handleGetVehiclesSuccess(response)
  {
    $scope.vehicles = response.vehicles;
    $scope.totalVehicles = response.total;
  };

  function getVehiclesComplete()
  {
    $scope.searching = false;
  };

  $scope.getVehicles();
}]);

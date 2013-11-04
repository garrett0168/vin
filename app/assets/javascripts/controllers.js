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
  $scope.carouselGridWidth = 5;
  $scope.loading = true;
  $scope.vehicle = Vehicle.get({vin: $routeParams.vin}, 
    function(resource) 
    {
      $scope.loading = false;
      if(resource && resource.vehicle_images && resource.vehicle_images.length > 0)
      {
        $scope.calculateCarouselWidth(resource.vehicle_images[0].medium_res_url);
      }
    }, 
    function(response) 
    {
      $scope.loading = false;
      $scope.vehicle = null;
    });

  $scope.calculateCarouselWidth = function(img0)
  {
    var match = img0.match(/(\d+)\..*/);
    if(match)
    {
      if(parseInt(match[1]) > 400)
      {
        $scope.carouselGridWidth = 6;
      }
      else
      {
        $scope.carouselGridWidth = 5;
      }
    }
  };

}]);

vinApp.controller('VehiclesIndexController', ['$scope', 'Vehicles', function($scope, Vehicles) {
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

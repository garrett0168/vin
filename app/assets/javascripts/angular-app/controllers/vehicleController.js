angular.module('vin.controllers').controller('VehicleController', ['$scope', '$routeParams', 'Vehicle', function($scope, $routeParams, Vehicle) {
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

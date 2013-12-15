angular.module('vin.controllers').controller('VehicleController', ['$scope', '$routeParams', 'Vehicle', 'reverseGeocoder', function($scope, $routeParams, Vehicle, reverseGeocoder) {
  $scope.carouselGridWidth = 5;
  $scope.loading = true;
  $scope.selectedStyle = null;
  $scope.vehicle = Vehicle.get({vin: $routeParams.vin}, 
    function(resource) 
    {
      $scope.loading = false;
      
      if(resource.styles.length > 0)
      {
        $scope.selectedStyle = resource.styles[0];
      }
      $scope.findTmv();
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

  $scope.currentZip = null;
  $scope.vehicleTmv = null;

  function onCreate() {
    if(Modernizr.geolocation)
    {
      navigator.geolocation.getCurrentPosition(function(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude; 

        var deferred = reverseGeocoder.lookup(latitude, longitude);
        deferred.then(function(response) {
          if(Array.isArray(response.data.postalCodes) && response.data.postalCodes.length > 0)
          {
            $scope.currentZip = response.data.postalCodes[0].postalCode;
            $scope.findTmv();
          }
        }, function(response) {
          if(console)
          {
            console.log("Unable to perform reverse geocoding -> Status code: " + response.status + ". Data: " + response.data);
          }
        });
      });
    }
  };

  $scope.findTmv = function()
  {
    if($scope.currentZip && $scope.vehicle && $scope.selectedStyle)
    {
      $scope.vehicle.lookupTmv($scope.currentZip, $scope.selectedStyle.edmunds_id);
    }
  }

  onCreate();

}]);

angular.module('vin.services').factory('reverseGeocoder', ['$rootScope', '$q', '$http', function($rootscope, $q, $http) {
  var service = function() 
  {
    this.lookup = function(lat, lng)
    {
      var url = "/reverse_geocoder/lookup?lat=" + lat + "&lng=" + lng;
      return $http({method: 'GET', url: url});
    }
  };

  return new service();

}]);

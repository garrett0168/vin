angular.module('vin.services').factory('Vehicle', ['$resource', '$http', function($resource, $http) {
  var Vehicle = $resource('/vehicles/by_vin/:vin', {
    query: {
      method: 'GET',
      isArray: false
    }
  });

  Vehicle.prototype.lookupTmv = function(zip, styleId)
  { 
    var self = this;
    var url = "/vehicles/" + this.id + "/tmv?zip=" + zip + "&styleId=" + styleId;

    var promise = $http({method: 'GET', url: url});
    promise.then(function(response) {
      self.tmv = response.data.tmv;
    }, function(response) {
      // Don't do anything. it's ok
    });
  };

  return Vehicle;
}]);


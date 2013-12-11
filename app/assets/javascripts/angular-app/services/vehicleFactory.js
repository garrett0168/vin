angular.module('vin.services').factory('Vehicle', ['$resource', function($resource) {
  return $resource('/vehicles/by_vin/:vin');
}]);


'use strict';

vinApp.factory('Vehicles', ['$resource', function($resource) {
  return $resource('/vehicles');
}]);

vinApp.factory('Vehicle', ['$resource', function($resource) {
  return $resource('/vehicles/by_vin/:vin');
}]);


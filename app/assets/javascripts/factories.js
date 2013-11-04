'use strict';

/*vinApp.factory('Vehicles', ['$resource', function($resource) {
  return $resource('/vehicles');
}]);*/
vinApp.factory('Vehicles', ['$http', '$q', function($http, $q) {
  var factory = function()
  {
    this.get = function(currentPage, vehiclesPerPage)
    {
      var searchResult = $q.defer();
      var url = "/vehicles";
      var params = {page: currentPage, per_page: vehiclesPerPage};
      $http({method: 'GET', url: url, params: params}).
        success(function(data, status, headers, config)
        {
          searchResult.resolve(data);
        }).
        error(function(data, status, headers, config)
        {
          searchResult.reject({data: data, status: status});
        });
      return searchResult.promise;
    }
  };

  return new factory();
}]);

vinApp.factory('Vehicle', ['$resource', function($resource) {
  return $resource('/vehicles/by_vin/:vin');
}]);


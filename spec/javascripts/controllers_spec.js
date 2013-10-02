'use strict';

/* jasmine specs for controllers go here */
describe('VIN decoder controllers', function() {
  var $scope = null;
  var $controller = null;
  var $httpBackend = null;
  var $location = null;

  beforeEach(function() {
    this.addMatchers({
      toEqualData: function(expect) {
        return angular.equals(expect, this.actual);
      }
    });
  });

  beforeEach(module('vinApp'));

  beforeEach(inject(function($rootScope, _$controller_, _$httpBackend_, _$location_) {
    $scope = $rootScope.$new();
    $controller = _$controller_;
    $httpBackend = _$httpBackend_;
    $location = _$location_;
  }));

  describe('VehiclesIndexController', function() {

    it('should query for some vehicles', function() {
      // Expect that the resource (or http) makes a request.
      $httpBackend.expect('GET', '/vehicles').respond([{id:1, vin:'1234567890'}, {id:2, vin:'2345678901'}]);
    
      var ctrl = $controller('VehiclesIndexController', {$scope: $scope});
    
      expect($scope.vehicles).toEqual([]);
    
      // Simulate server response.
      $httpBackend.flush();
    
      expect($scope.vehicles).toEqualData([{id:1, vin:'1234567890'}, {id:2, vin:'2345678901'}]);
      expect($scope.totalVehicles).toEqual(2);
    });

    it('should handle pagination locally', function() {
      $httpBackend.expect('GET', '/vehicles').respond([{id:1, vin:'1234567890'}, {id:2, vin:'2345678901'}, 
        {id:3, vin:'123'}, {id:4, vin:'456'}, {id:5, vin:'789'},
        {id:6, vin:'101112'}, {id:7, vin:'131415'}, {id:8, vin:'161718'}]);
    
      var ctrl = $controller('VehiclesIndexController', {$scope: $scope});
    
      // Simulate server response.
      $httpBackend.flush();

      // First page
      $scope.filter();
      expect($scope.vehiclesFiltered).toEqualData([{id:1, vin:'1234567890'}, {id:2, vin:'2345678901'}, {id:3, vin:'123'}, {id:4, vin:'456'}, {id:5, vin:'789'}]);

      // Next page
      $scope.currentPage = 2;
      $scope.filter();
      expect($scope.vehiclesFiltered).toEqualData([{id:6, vin:'101112'}, {id:7, vin:'131415'}, {id:8, vin:'161718'}]);
    });
  });

  describe('VehicleSearchController', function() {
    it('has an empty vin by default', function() {
      var ctrl = $controller('VehicleSearchController', {$scope: $scope});
      expect($scope.vin).toEqual('');
    });

    it('can decode a VIN', function() {
      var ctrl = $controller('VehicleSearchController', {$scope: $scope});
      $scope.vin = "12345";

      $scope.submitVin();

      expect($location.path()).toBe('/vehicles/by_vin/12345');
    });

    it('can handle typeahead and cache the responses', function() {
      var ctrl = $controller('VehicleSearchController', {$scope: $scope});
      $httpBackend.expect('GET', '/vehicles/typeahead_vin/Z').respond(["ZHWUC1ZD5DLA01714", "ZQWUC1ZD5DLA01714"]);
      $scope.vinTypeahead("Z");
      $httpBackend.flush();

      expect($scope.typeahead_cache["Z"]).toEqual(["ZHWUC1ZD5DLA01714", "ZQWUC1ZD5DLA01714"]);

      var typeahead = $scope.vinTypeahead("Z");
      $httpBackend.verifyNoOutstandingRequest();
      expect(typeahead).toEqual(["ZHWUC1ZD5DLA01714", "ZQWUC1ZD5DLA01714"]);

      $httpBackend.expect('GET', '/vehicles/typeahead_vin/ZH').respond(["ZHWUC1ZD5DLA01714"]);
      $scope.vinTypeahead("ZH");
      $httpBackend.flush();

      expect($scope.typeahead_cache["ZH"]).toEqual(["ZHWUC1ZD5DLA01714"]);

      typeahead = $scope.vinTypeahead("ZH");
      $httpBackend.verifyNoOutstandingRequest();
      expect(typeahead).toEqual(["ZHWUC1ZD5DLA01714"]);
    });
  });

  describe('VehicleByVinController', function() {
    it('should automatically load the vehicle', function() {
      // Expect that the resource (or http) makes a request.
      $httpBackend.expect('GET', '/vehicles/by_vin/12345').respond({id:1, vin:'12345', make:'Lamborghini'});
    
      var ctrl = $controller('VehicleByVinController', {$scope: $scope, $routeParams: {vin: '12345'}});
    
      // Simulate server response.
      $httpBackend.flush();
    
      expect($scope.vehicle).toEqualData({id:1, vin:'12345', make:'Lamborghini'});
    });
  });
});

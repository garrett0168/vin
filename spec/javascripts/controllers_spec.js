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
    });
  });

  describe('VehicleSearchController', function() {
    it('has an empty vin by default', function() {
      var ctrl = $controller('VehicleSearchController', {$scope: $scope});
      expect($scope.vin).toEqual('');
    });

    it('decode a VIN', function() {
      var ctrl = $controller('VehicleSearchController', {$scope: $scope});
      $scope.vin = "12345";

      $scope.submitVin();

      expect($location.path()).toBe('/vehicles/by_vin/12345');
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

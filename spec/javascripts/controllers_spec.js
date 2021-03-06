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

  beforeEach(module('vin'));

  beforeEach(inject(function($rootScope, _$controller_, _$httpBackend_, _$location_) {
    $scope = $rootScope.$new();
    $controller = _$controller_;
    $httpBackend = _$httpBackend_;
    $location = _$location_;
  }));

  describe('VehiclesIndexController', function() {

    it('should query for some vehicles', function() {
      // Expect that the resource (or http) makes a request.
      var vehicles = [{id:1, vin:'1234567890'}, {id:2, vin:'2345678901'}];
      $httpBackend.expect('GET', '/vehicles?page=1&per_page=5').respond({total: 2, vehicles: vehicles});
    
      var ctrl = $controller('IndexController', {$scope: $scope});
    
      expect($scope.vehicles).toEqual([]);
    
      // Simulate server response.
      $httpBackend.flush();
    
      expect($scope.vehicles).toEqualData(vehicles);
      expect($scope.totalVehicles).toEqual(2);
    });

    it('should handle pagination', function() {
      var vehicles1 = [{id:1, vin:'1234567890'}, {id:2, vin:'2345678901'}, 
        {id:3, vin:'123'}, {id:4, vin:'456'}, {id:5, vin:'789'}];
      var vehicles2 = [{id:6, vin:'101112'}, {id:7, vin:'131415'}, {id:8, vin:'161718'}];
      $httpBackend.expect('GET', '/vehicles?page=1&per_page=5').respond({total: 8, vehicles: vehicles1});
    
      var ctrl = $controller('IndexController', {$scope: $scope});
    
      // Simulate server response.
      $httpBackend.flush();

      // First page
      expect($scope.vehicles).toEqualData(vehicles1);

      // Next page
      $scope.currentPage = 2;
      $httpBackend.expect('GET', '/vehicles?page=2&per_page=5').respond({total: 8, vehicles: vehicles2});
      $httpBackend.flush();
      expect($scope.vehicles).toEqualData(vehicles2);
    });
  });

  describe('VehicleSearchController', function() {
    it('has an empty vin by default', function() {
      var ctrl = $controller('SearchController', {$scope: $scope});
      expect($scope.vin).toEqual('');
    });

    it('can decode a VIN', function() {
      var ctrl = $controller('SearchController', {$scope: $scope});
      $scope.vin = "12345";

      $scope.submitVin();

      expect($location.path()).toBe('/vehicles/by_vin/12345');
    });

    it('can handle typeahead and cache the responses', function() {
      var ctrl = $controller('SearchController', {$scope: $scope});
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
    var lambo = {id:1, vin:'12345', make:'Lamborghini', styles:[{id:1,edmunds_id:"123",name:"Lambo",body:"Coupe",year:2013}], options:[], colors:[]};
    it('should automatically load the vehicle', function() {
      // Expect that the resource (or http) makes a request.
      $httpBackend.expect('GET', '/vehicles/by_vin/12345?query=%7B%22method%22:%22GET%22,%22isArray%22:false%7D').respond(lambo);
    
      var ctrl = $controller('VehicleController', {$scope: $scope, $routeParams: {vin: '12345'}});
    
      // Simulate server response.
      $httpBackend.flush();
    
      expect($scope.vehicle).toEqualData(lambo);
    });

    it('should compute the image carousel width based on an image url', function() {
      $httpBackend.expect('GET', '/vehicles/by_vin/12345?query=%7B%22method%22:%22GET%22,%22isArray%22:false%7D').respond(lambo);
      var ctrl = $controller('VehicleController', {$scope: $scope, $routeParams: {vin: '12345'}});

      $httpBackend.flush();

      $scope.calculateCarouselWidth("/lexus/rx-350/2013/oem/2013_lexus_rx-350_4dr-suv_base_d_oem_1_423.jpg");
      expect($scope.carouselGridWidth).toEqual(6);

      $scope.calculateCarouselWidth("/lamborghini/aventador/2012/oem/2012_lamborghini_aventador_coupe_lp-700-4_detail_oem_2_276.jpg");
      expect($scope.carouselGridWidth).toEqual(5);
    });

    it('should track whether it is loading the resource from the server', function() {
      $httpBackend.expect('GET', '/vehicles/by_vin/12345?query=%7B%22method%22:%22GET%22,%22isArray%22:false%7D').respond(lambo);
      var ctrl = $controller('VehicleController', {$scope: $scope, $routeParams: {vin: '12345'}});

      expect($scope.loading).toEqual(true);

      $httpBackend.flush();

      expect($scope.loading).toEqual(false);
    });
  });
});

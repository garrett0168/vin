'use strict';

var vinApp = angular.module('vinApp', ['ngResource'])
    .config(['$routeProvider', function($routeProvider, $locationProvider) {
        $routeProvider
            .when('/',     {controller: 'VehicleSearchController',    templateUrl: '/assets/index.html'})
            .when('/vehicles', {controller: 'VehiclesIndexController',   templateUrl: '/assets/vehicles/index.html'})
            .when('/vehicles/by_vin/:vin', {controller: 'VehicleByVinController',     templateUrl: '/assets/vehicles/by_vin.html'})
            .otherwise({redirectTo: '/'});
    }]);

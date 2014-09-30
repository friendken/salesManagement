'use strict';

var dashboard = angular.module('dashboard', [
    'ui.router',
//  'ngRoute',
//  'dashboard.filters',
  'dashboard.services',
  'dashboard.directives',
  'dashboard.controllers'
]).
config(function($stateProvider, $urlRouterProvider) {
  //
  // For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("/dashboard");
  //
  // Now set up the states
  $stateProvider
    .state('dashboard', {
      url: "/dashboard",
      views: {
        "content": { templateUrl: '/www/partials/temp-dashboard.html'}
      },
      controller: 'dashboardController'
    })
    .state('product-type', {
      url: "/product-type",
      views: {
        "content": { templateUrl: '/www/partials/temp-create-product-type.html'}
      },
      controller: 'productTypeController'
    })
});

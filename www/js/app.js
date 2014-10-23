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
      url: "dashboard",
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
    .state('create-product', {
      url: "/create-product",
      views: {
        "content": { templateUrl: '/www/partials/temp-create-product.html'}
      },
      controller: 'createProductController'
    })
    .state('product', {
      url: "/product",
      views: {
        "content": { templateUrl: '/www/partials/temp-product.html'}
      },
      controller: 'productController'
    })
    .state('edit-product', {
      url: "/edit-product/:id",
      views: {
        "content": { templateUrl: '/www/partials/temp-create-product.html'}
      },
      controller: 'createProductController'
    })
    .state('warehouse-invoice', {
      url: "/warehouse-invoice/:type",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse-wholesale.html'}
      },
      controller: 'warehouseWholesaleController'
    })
    .state('warehouse', {
      url: "/warehouse/:type",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse.html'}
      },
      controller: 'warehouseController'
    })
    .state('stock-transfer', {
      url: "/stock-transfer",
      views: {
        "content": { templateUrl: '/www/partials/temp-stock-transfer.html'}
      },
      controller: 'stockTransferController'
    })
    .state('warehouse-sale', {
      url: "/warehouse-sale/:type",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse-sale.html'}
      },
      controller: 'warehouseSaleController'
    })
    .state('bill', {
      url: "/bill/:type",
      views: {
        "content": { templateUrl: '/www/partials/temp-bill.html'}
      },
      controller: 'billController'
    })
    .state('bill-detail', {
      url: "/bill-detail/:type/:id",
      views: {
        "content": { templateUrl: '/www/partials/temp-bill-detail.html'}
      },
      controller: 'billDetailController'
    })
});

'use strict';

var dashboard = angular.module('dashboard', [
    'ui.router',
    'ui.bootstrap',
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
    .state('warehouse-divide', {
      url: "/warehouse-divide/:warehousing_id",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse-divide.html'}
      },
      controller: 'warehouseDivideController'
    })
    .state('warehouse-list', {
      url: "/warehouse-list",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse-list.html'}
      },
      controller: 'warehouseListController'
    })
    .state('warehouse-status', {
      url: "/warehouse-status",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse-status.html'}
      },
      controller: 'warehouseStatusController'
    })
    .state('warehouse-outofstorge', {
      url: "/warehouse-outofstorge",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouse-outOfStorge.html'}
      },
      controller: 'warehouseOutOfStorgeController'
    })
    .state('total-liability', {
      url: "/total-liability",
      views: {
        "content": { templateUrl: '/www/partials/temp-total-liability.html'}
      },
      controller: 'totalLiabilityController'
    })
    .state('total-debit', {
      url: "/total-debit",
      views: {
        "content": { templateUrl: '/www/partials/temp-total-debit.html'}
      },
      controller: 'totalDebitController'
    })
    .state('warehousing-history', {
      url: "/warehousing-history",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehousing-history.html'}
      },
      controller: 'warehousingHistoryController'
    })
});

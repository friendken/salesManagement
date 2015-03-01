'use strict';

var dashboard = angular.module('dashboard', [
    'ui.router',
    'ui.bootstrap',
    'dashboard.services',
    'dashboard.directives',
    'dashboard.controllers'
]).
config(function($stateProvider, $urlRouterProvider) {
  //
  // For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("/");
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
    .state('total-debit-customer', {
      url: "/total-debit-customer/:customer_id",
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
    .state('warehousing-detail', {
      url: "/warehousing-detail/:id",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehousing-detail.html'}
      },
      controller: 'warehousingDetailController'
    })
    .state('warehouses-transfer', {
      url: "/warehouses-transfer",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouses-transfer.html'}
      },
      controller: 'warehousesTransferController'
    })
    .state('warehouses-export', {
      url: "/warehouses-export",
      views: {
        "content": { templateUrl: '/www/partials/temp-warehouses-export.html'}
      },
      controller: 'warehousesExportController'
    })
    .state('export-detail', {
      url: "/export-detail/:id",
      views: {
        "content": { templateUrl: '/www/partials/temp-export-detail.html'}
      },
      controller: 'exportDetailController'
    })
    .state('customers', {
      url: "/customers/:type",
      views: {
        "content": { templateUrl: '/www/partials/temp-customers.html'}
      },
      controller: 'customersController'
    })
    .state('order-create', {
      url: "/order-create",
      views: {
        "content": { templateUrl: '/www/partials/temp-order-create.html'}
      },
      controller: 'createOrderController'
    })
    .state('order-management', {
      url: "/order-management",
      views: {
        "content": { templateUrl: '/www/partials/temp-order-management.html'}
      },
      controller: 'managementOrderController'
    })
    .state('order-divide', {
      url: "/order-divide/:shipment_id",
      views: {
        "content": { templateUrl: '/www/partials/temp-order-divide.html'}
      },
      controller: 'divideOrderController'
    })
    .state('order-status', {
      url: "/order-status",
      views: {
        "content": { templateUrl: '/www/partials/temp-order-status.html'}
      },
      controller: 'statusOrderController'
    })
    .state('order-return', {
      url: "/order-return/:order_id",
      views: {
        "content": { templateUrl: '/www/partials/temp-order-return.html'}
      },
      controller: 'returnOrderController'
    })
    .state('order-return-half', {
      url: "/order-return-half/:order_id/:bill_id",
      views: {
        "content": { templateUrl: '/www/partials/temp-order-return-half.html'}
      },
      controller: 'returnOrderHalfController'
    })
    .state('trucks', {
      url: "/trucks",
      views: {
          "content": { templateUrl: '/www/partials/temp-trucks.html'}
      },
      controller: 'trucksController'
    })
    .state('staff', {
      url: "/staff",
      views: {
          "content": { templateUrl: '/www/partials/temp-staff.html'}
      },
      controller: 'staffController'
    })
  .state('staff-create', {
      url: "/staff-create",
      views: {
          "content": { templateUrl: '/www/partials/temp-staff-create.html'}
      },
      controller: 'createStaffController'
  })
  .state('staff-edit', {
      url: "/staff-edit/:id",
      views: {
          "content": { templateUrl: '/www/partials/temp-staff-create.html'}
      },
      controller: 'createStaffController'
  })
  .state('order-list', {
      url: "/order-list",
      views: {
          "content": { templateUrl: '/www/partials/temp-order-list.html'}
      },
      controller: 'listOrderController'
  })
  .state('order-detail', {
      url: "/order-detail/:order_id",
      views: {
          "content": { templateUrl: '/www/partials/temp-order-detail.html'}
      },
      controller: 'detailOrderController'
  })
  .state('users', {
      url: "/users",
      views: {
          "content": { templateUrl: '/www/partials/temp-user-list.html'}
      },
      controller: 'listUserController'
  })
  .state('shipment', {
      url: "/shipment",
      views: {
          "content": { templateUrl: '/www/partials/temp-shipment.html'}
      },
      controller: 'shipmentController'
  })
  .state('shipment-detail', {
      url: "/shipment-detail/:shipment_id",
      views: {
          "content": { templateUrl: '/www/partials/temp-shipment-detail.html'}
      },
      controller: 'shipmentDetailController'
  })
});

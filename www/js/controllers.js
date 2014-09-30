'use strict';

/* Controllers */

angular.module('dashboard.controllers', ['ui.bootstrap'])
    .controller('dashboardController', ['$scope', function($scope) {
        console.log('load ok');
//            tooltip_ob();
//            setPosConfirm(50);
//            $scope.data = 'dsv';
//            $scope.exitOnboard = function() {
//              updateLogin.update().success(function(reponse) {
//                window.location.href = config.base + 'home';
//              });
//            }

    }])
    .controller('productTypeController', ['$scope', '$http', function($scope,$http) {
        console.log('load product type');
        $scope.createType = true;
        $scope.showCreateType = function(){
            $scope.createType = false;
        };
        $scope.cancelCreate = function(){
            $scope.createType = true;
            $scope.product_type_name = '';
            $scope.product_description = '';
        };
        $scope.saveProductType = function(){
            $http({method: 'post', url: config.base + 'apps/account/common/basic/getStates',
                
                reponseType: 'json'}).
                success(function(data, status) {

                }).
                error(function(data, status) {
                  console.log(data);
                });
            };
    }])
        

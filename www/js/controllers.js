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
        $scope.showSuccess = function(delay,str){
           if(delay){
                $('#alertMessage').removeClass('error info warning').addClass('success').html(str).stop(true,true).show().animate({ opacity: 1,right: '10'}, 500,function(){
                                $(this).delay(delay).animate({ opacity: 0,right: '-20'}, 500,function(){ $(this).hide(); });																														   																											
                      });
                return false;
            }
            $('#alertMessage').addClass('success').html(str).stop(true,true).show().animate({ opacity: 1,right: '10'}, 500);	
        }
        $scope.saveProductType = function(){
            $http({method: 'post', url: config.base + '/product_type/createProductType',
                data: {type_name: $scope.product_type_name, description: $scope.product_description},
                reponseType: 'json'}).
                success(function(data, status) {
                    $scope.cancelCreate();
                    $scope.showSuccess(3000,'lưu thành công');
                    console.log(data);
                }).
                error(function(data, status) {
                  console.log(data);
                });
            };
    }])
        

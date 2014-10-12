'use strict';

/* Controllers */

angular.module('dashboard.controllers', ['ui.bootstrap'])
    .controller('dashboardController', ['$scope', function($scope) {
        console.log('load ok');
    }])
    .controller('productTypeController', ['$scope', '$http','showAlert', function($scope,$http,showAlert) {
        console.log('load product type');
        
        $scope.init = function(){
            $http({method: 'GET', url: config.base + '/product_type', reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                    $scope.products = data;
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data)
                });
        }
        $scope.init();
        
        $scope.datatable = function(){
            $('#tabel_product_type').dataTable();
        }
//        $scope.datatable();
        $scope.editProduct = function(el){
            $scope.changeView('edit','cancel',el.item.id)
        }
        $scope.updateProduct = function(el){
            $http({method: 'POST', url: config.base + '/product_type/updateProductType',
                data:{id: el.item.id, name: $('#cancel_name_' + el.item.id).val()}, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                  $scope.init();
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data)
                });
        }
        $scope.cancelProduct = function(el){
            $scope.changeView('cancel','edit',el.item.id)
        }
        $scope.changeView = function(show,hide,id){
            $('#' + show + '_name_' + id).hide();
            $('#' + hide + '_name_' + id).show();   
            $('#' + show + '_btn_' + id).hide();
            $('#' + hide + '_btn_' + id).show();   
        }
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
            $http({method: 'post', url: config.base + '/product_type/createProductType',
                data: {name: $scope.product_type_name, description: $scope.product_description},
                reponseType: 'json'}).
                success(function(data, status) {
                    $scope.cancelCreate();
                    showAlert.showSuccess(3000,'lưu thành công');
                    $scope.init();
                    
                }).
                error(function(data, status) {
                  console.log(data);
                });
            };
    }])
    .controller('createProductController', ['$scope','$http','showAlert','$stateParams','$location', function($scope,$http,showAlert,$stateParams,$location) {
        if($stateParams.id){
            $scope.url = config.base + '/products/createProductView?id=' + $stateParams.id;
            $scope.urlSave = config.base + '/products/editProduct?id=' + $stateParams.id;
        }else{
            $scope.url = config.base + '/products/createProductView';
            $scope.urlSave = config.base + '/products/createProduct';
        }
        $scope.product = {};
        $scope.init = function(){
            $http({method: 'GET', url: $scope.url, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
//                   console.log(data.product_type)
                    $scope.product_type = data.product_type;
                    $scope.product.product_type = data.product_type[0]
                    $scope.product.sale_price = [{id:1, name: '',quantity: '',price: '',parent_name: ''}]
                    if(data.products){
                         $scope.product = data.products;
                         var position = parseInt(data.products.sale_price.length) - 1;
                         $('#btn_more_price').data('id',data.products.sale_price[position].id);
                     }
                    
//                    $scope.product.product_type = data.product_type[0]
//                    $('.chzn-select').selectmenu({
//                        style: 'dropdown',
//                        transferClasses: true,
//                        width: null
//                    });
                }).
                error(function(data, status) {
                  console.log(data)
                });
        }
        $scope.init();
        $scope.morePrice = function (){
            var tr_id = $('#btn_more_price').data('id');
            var template = $('#tr_product_price_' + tr_id)
            var unit = template.children('td:nth-child(3)').children().val()
            if(unit.trim() == ''){
                template.children('td:nth-child(3)').children().addClass('error')
                return false;
            }
            template.children('td:nth-child(3)').children().removeClass('error')
                
            $('#btn_more_price').data('id',(parseInt(tr_id) + 1))
            $('.list_product_price').append('<tr class="product_price" id="tr_product_price_' + (tr_id + 1) +'">' + template.html() + '</tr>');
            var new_template = $('#tr_product_price_' + (tr_id + 1))
            $('#tr_product_price_' + (tr_id + 1) + ' input').val('');
            new_template.children('td:nth-child(1)').text(unit + ' =')
        }
        $scope.createProduct = function (){
            var list_price = new Array();
            $('.product_price').each(function(){
                list_price.push([{quantity: $(this).children('td:nth-child(2)').children().val()},
                                {name: $(this).children('td:nth-child(3)').children().val()},
                                {price: $(this).children('td:nth-child(4)').children().val()}])
            })
            $scope.product.sale_price = list_price;
            var product = {name: $scope.product.name,
                           code: $scope.product.code,
                           description: $scope.product.description,
                           product_type: $scope.product.product_type.id,
                           list_price: $scope.product.sale_price}
            $http({method: 'post', url: $scope.urlSave,
               data: product, reponseType: 'json'}).
               success(function(data, status) {
                   console.log(data)
//                   $scope.cancelCreate();
                   showAlert.showSuccess(3000,'lưu thành công');
                   $location.path('product');
//                   $scope.init();

               }).
               error(function(data, status) {
                 console.log(data);
               });
        }
    }])
    .controller('productController', ['$scope','$http', function($scope,$http) {
            console.log('load product list');
            $http({method: 'GET', url: config.base + '/products', reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                    $scope.products = data;
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data)
                });
    }])
    .controller('warehouseWholesaleController', ['$scope','$http','showAlert', function($scope,$http,showAlert) {
            console.log('load warehouse-wholesale');
            $scope.url = config.base + '/warehouse_wholesale/saveAddWholesale';
            $scope.wholesale = {}
            $scope.wholesale.partner = 1;
            $scope.wholesale.total_bill = 0
            $scope.show_total_bill = 0;
            $scope.init = function(){
                $http({method: 'GET', url: config.base + '/warehouse_wholesale/addWholesale', reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                        var html_select = '';
                        for(var x in data.products){
                            html_select += '<option value="' + data.products[x].id + '">' + data.products[x].name + '</option>'
                        }
                        $('#tr_product_buy_price_1 select').append(html_select);
                        $scope.initSelect();
                        
    //                    $('#tabel_product_type').dataTable();
                    }).
                    error(function(data, status) {
                      console.log(data)
                    });
            }
            $scope.init();
            $scope.initSelect = function (){
                $(' select').not("select.chzn-select,select[multiple],select#box1Storage,select#box2Storage").selectmenu({
                    style: 'dropdown',
                    transferClasses: true,
                    width: null
                });
                
                $(".chzn-select").chosen(); 
            }
            $scope.moreBuy = function(){
                var tr_id = $('.btn_more_buy').data('id');
                var template = $('#tr_product_buy_price_' + tr_id)
                var new_id = tr_id + 1;
                
                if(template.children('td:nth-child(3)').children('input').val().trim() == '' || template.children('td:nth-child(5)').children('input').val().trim() == '')
                    return false;
                if(isNaN(template.children('td:nth-child(3)').children('input').val().trim())){
                    template.children('td:nth-child(3)').children('input').addClass('error')
                    return false
                }else if(isNaN(template.children('td:nth-child(5)').children('input').val().trim())){
                    template.children('td:nth-child(5)').children('input').addClass('error')
                    return false
                }else
                    $('input[type=text]').removeClass('error')
                    
                var quantity = template.children('td:nth-child(3)').children('input').val().trim()
                var price = template.children('td:nth-child(5)').children('input').val().trim()
                var total = parseInt(quantity) * parseInt(price)
                $scope.wholesale.total_bill += total;
                $scope.show_total_bill = numeral($scope.wholesale.total_bill).format('0,0');
                $('.btn_more_buy').data('id',new_id);
                var select = $('#tr_product_buy_price_' + tr_id + ' select').html();
                select = '<select data-placeholder="sản phẩm" class="chzn-select">' + select +'</select>'

                template.after('<tr class="product_buy_price" id="tr_product_buy_price_' + new_id +'">' + template.html() + '</tr>')
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(2)').html(select)
                $('#tr_product_buy_price_' + tr_id).children('td:nth-child(6)').html('<h4>' + numeral(total).format('0,0') + '</h4>')
                $('#tr_product_buy_price_' + new_id + ' div.iconBox').remove();
                $scope.initSelect();
            }
            
            $scope.addWhole = function(){
                
                var buy_price = new Array();
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(3)').children('input').val().trim() != '' || $(this).children('td:nth-child(5)').children('input').val().trim() != ''){
                       buy_price.push({product_id: $(this).children('td:nth-child(2)').children('select').val(),
                                   quantity: $(this).children('td:nth-child(3)').children('input').val(),
                                   unit: $(this).children('td:nth-child(4)').children('input').val(),
                                   price: $(this).children('td:nth-child(5)').children('input').val()}) 
                   }
                });
                if(buy_price.length == 0){
                    alert('vui lòng nhập sản phẩn vào kho');
                    return false;
                } 
                $scope.wholesale.buy_price = buy_price;
                
                //======= send request =======
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            console.log(data)
         //                   $scope.cancelCreate();
                            showAlert.showSuccess(3000,'lưu thành công');
//                            $location.path('product');
         //                   $scope.init();

                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                
            }
    }])
    
        

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

                }).
                error(function(data, status) {
                  console.log(data)
                });
        }
        $scope.init();
        
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
            var new_id = parseInt(tr_id) + 1;
            $('#btn_more_price').data('id',new_id)
            $('.list_product_price').append('<tr class="product_price" id="tr_product_price_' + new_id +'">' + template.html() + '</tr>');
            var new_template = $('#tr_product_price_' + new_id)
            $('#tr_product_price_' + new_id + ' input').val('');
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
            $scope.init = function(){
                $http({method: 'GET', url: config.base + '/products', reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                        $scope.products = data.products;
                        var html_select = '';
                        for(var x in data.product_type){
                            html_select += '<option value="' + data.product_type[x].id + '">' + data.product_type[x].name + '</option>'
                        }
                        $('#filter_product_type').append(html_select);
                        $scope.initSelect();
                        
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
            $scope.refeshTable = function(){
                $scope.init();
            }
    }])
    .controller('warehouseWholesaleController', ['$scope','$http','$stateParams','showAlert', function($scope,$http,$stateParams,showAlert) {
            console.log('load warehouse-wholesale');
            if($stateParams.type == 'wholesale'){
                $scope.url = config.base + '/warehouse_wholesale/saveAddWholesale';
                $scope.warehouse_type = 'Sỉ';
            }
            else{
                $scope.url = config.base + '/warehouse_retail/saveAddRetail';
                $scope.warehouse_type = 'Lẻ';
            }
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
                        $('#tr_product_buy_price_1 select.load_product').append(html_select);
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
//            $scope.initSelect();
            $scope.moreBuy = function(){
                //get template and new tr_id
                var tr_id = $('.btn_more_buy').data('id');
                var template = $('#tr_product_buy_price_' + tr_id)
                var quantity = template.children('td:nth-child(4)').children().val().trim();
                var price = template.children('td:nth-child(6)').children().val().trim();
                if(quantity == '' || isNaN(quantity))
                    return false
                if(price == '' || isNaN(price))
                    return false
                
                var new_id = tr_id + 1;
                $('.btn_more_buy').data('id',new_id);
                
                
                
                //get select product and clone it
                var select = $('#tr_product_buy_price_' + tr_id + ' select').html();
                select = '<select data-placeholder="sản phẩm" onchange="loadUnitProduct(this)" class="chzn-select">' + select +'</select>'
                
                //get select unit prodcut and clone it
                var select_unit = $('#tr_product_buy_price_' + tr_id + ' select.load_unit').html();
                select_unit = '<select data-placeholder="sản phẩm" class="chzn-select">' + select_unit +'</select>'
                
                //clone template and remove date
                template.after('<tr class="product_buy_price" id="tr_product_buy_price_' + new_id +'">' + template.html() + '</tr>')
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(3)').html(select)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(2)').text(new_id)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(5)').html(select_unit)
                $('#tr_product_buy_price_' + new_id + ' div.iconBox').remove();
                $('#tr_product_buy_price_' + new_id).data('id', new_id)
                
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').prop('id','show_bill_product_' + new_id)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').prop('id','txt_hide_' + new_id)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').html('');
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').val(0);
                $scope.initSelect();
            }
            
            $scope.addWhole = function(){
                
                var buy_price = new Array();
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(4)').children('input').val().trim() != '' || $(this).children('td:nth-child(6)').children('input').val().trim() != ''){
                       buy_price.push({product_id: $(this).children('td:nth-child(3)').children('select').val(),
                                        quantity: $(this).children('td:nth-child(4)').children('input').val(),
                                        unit: $(this).children('td:nth-child(5)').children('select').val(),
                                        price: $(this).children('td:nth-child(7)').children('input').val()}) 
                   }
                });
                
                if(buy_price.length == 0){
                    alert('vui lòng nhập sản phẩn vào kho');
                    return false;
                } 
                $scope.wholesale.buy_price = buy_price;
                $scope.wholesale.total_bill = $('#txt_hide_total_bill').val();
                
                //======= send request =======
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            console.log(data)
                            showAlert.showSuccess(3000,'lưu thành công');
//                            $location.path('product');
                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                
            }
    }])
    .controller('warehouseController', ['$scope','$http','$stateParams', function($scope,$http,$stateParams) {
                console.log('load warehouse');
                if ($stateParams.type == 'wholesale'){
                    $scope.urlLoad = config.base + '/warehouse_wholesale';
                    $scope.product_name_type = 'Sỉ'
                }else{
                    $scope.urlLoad = config.base + '/warehouse_retail';
                    $scope.product_name_type = 'Lẻ'
                }
                $scope.init = function(){
                    $http({method: 'GET', url: $scope.urlLoad, reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                      console.log(data);
                      $scope.products = data.products;
    //                    $('#tabel_product_type').dataTable();
                    }).
                    error(function(data, status) {
                      console.log(data)
                    });
                }
                $scope.init();
        }])
        .controller('stockTransferController', ['$scope','$http','showAlert', function($scope,$http, showAlert) {
            console.log('load stock transfer');
            $scope.init = function(){
            $http({method: 'GET', url: config.base + '/stock_transfer', reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                    $scope.wholesale_products = data.wholesale_products;
                    $scope.retail_products = data.retail_products;
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data)
                });
            }
            $scope.init();
            $scope.transfer = function(el){
                var quantity = $('#quantity_transfer_' + el.item.product_id).val();
                if(quantity == '' || isNaN(quantity)){
                    $('#quantity_transfer_' + el.item.product_id).addClass('error')
                    alert('vui lòng kiểm tra lại số lượng nhập');
                    return false;
                }
                if(parseInt(quantity) > parseInt(el.item.quantity)){
                    $('#quantity_transfer_' + el.item.product_id).addClass('error')
                    alert('số lượng trong kho không đủ để chuyển');
                    return false;
                }
                $('#quantity_transfer_' + el.item.product_id).removeClass('error')
                if(confirm('bạn có chắc muốn chuyển ' + quantity + ' ' + el.item.unit_name + ' ' + el.item.name)){
                    $http({method: 'post', url: config.base + '/stock_transfer/doTransfer',
                        data: {product_id: el.item.product_id,quantity: quantity}, reponseType: 'json'}).
                        success(function(data, status) {
                            console.log(data)
                            showAlert.showSuccess(3000,'chuyển thành công');
                            $scope.init();
//                            $location.path('product');
                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                }
            }
        }])
        .controller('warehouseSaleController', ['$scope','$http','$stateParams','showAlert', function($scope,$http,$stateParams,showAlert) {
            console.log('load warehouse-sale');
            if($stateParams.type == 'wholesale'){
                $scope.url = config.base + '/warehouse_wholesale_sale/createBill';
                $scope.load_product = config.base + '/warehouse_wholesale';
                $scope.warehouse_type = 'Sỉ';
            }
            else{
                $scope.url = config.base + '/warehouse_retail_sale/createBill';
                $scope.load_product = config.base + '/warehouse_retail';
                $scope.warehouse_type = 'Lẻ';
            }
            $scope.wholesale = {}
            $scope.wholesale.partner = 1;
            $scope.wholesale.total_bill = 0
            $scope.show_total_bill = 0;
            $scope.init = function(){
                $http({method: 'GET', url: $scope.load_product, reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                        var html_select = '';
                        for(var x in data.products){
                            html_select += '<option value="' + data.products[x].product_id + '">' + data.products[x].name + '</option>'
                        }
                        $('#tr_product_buy_price_1 select.load_product').append(html_select);
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
//            $scope.initSelect();
            $scope.moreBuy = function(){
                //get template and new tr_id
                var tr_id = $('.btn_more_buy').data('id');
                var template = $('#tr_product_buy_price_' + tr_id)
                var quantity = template.children('td:nth-child(4)').children().val().trim();
                var price = template.children('td:nth-child(6)').children().val().trim();
                if(quantity == '' || isNaN(quantity))
                    return false
                if(price == '' || isNaN(price))
                    return false
                
                var new_id = tr_id + 1;
                $('.btn_more_buy').data('id',new_id);
                
                
                
                //get select product and clone it
                var select = $('#tr_product_buy_price_' + tr_id + ' select').html();
                select = '<select data-placeholder="sản phẩm" onchange="loadUnitProduct(this,true)" class="chzn-select">' + select +'</select>'
                
                //get select unit prodcut and clone it
                var select_unit = $('#tr_product_buy_price_' + tr_id + ' select.load_unit').html();
                select_unit = '<select data-placeholder="sản phẩm" class="chzn-select">' + select_unit +'</select>'
                
                //clone template and remove date
                template.after('<tr class="product_buy_price" id="tr_product_buy_price_' + new_id +'">' + template.html() + '</tr>')
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(3)').html(select)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(2)').text(new_id)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(5)').html(select_unit)
                $('#tr_product_buy_price_' + new_id + ' div.iconBox').remove();
                $('#tr_product_buy_price_' + new_id).data('id', new_id)
                
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').prop('id','show_bill_product_' + new_id)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').prop('id','txt_hide_' + new_id)
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').html('');
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').val(0);
                $scope.initSelect();
            }
            
            $scope.createBill = function(){
                
                var buy_price = new Array();
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(4)').children('input').val().trim() != '' || $(this).children('td:nth-child(6)').children('input').val().trim() != ''){
                       buy_price.push({product_id: $(this).children('td:nth-child(3)').children('select').val(),
                                        quantity: $(this).children('td:nth-child(4)').children('input').val(),
                                        unit: $(this).children('td:nth-child(5)').children('select').val(),
                                        price: $(this).children('td:nth-child(7)').children('input').val()}) 
                   }
                });
                
                if(buy_price.length == 0){
                    alert('vui lòng chọn sản phẩm bán');
                    return false;
                } 
                $scope.wholesale.buy_price = buy_price;
                $scope.wholesale.total_bill = $('#txt_hide_total_bill').val();
//                console.log($scope.wholesale);return false;
                //======= send request =======
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            console.log(data)
                            showAlert.showSuccess(3000,'lưu thành công');
//                            $location.path('product');
                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                
            }
    }])
    .controller('billController', ['$scope','$http','$stateParams', function($scope,$http,$stateParams) {
            console.log('load bill');
            if ($stateParams.type == 'wholesale'){
                $scope.urlLoad = config.base + '/warehouse_wholesale_sale';
                $scope.product_name_type = 'Sỉ'
                $scope.type = 'wholesale'
            }else{
                $scope.urlLoad = config.base + '/warehouse_retail_sale';
                $scope.product_name_type = 'Lẻ'
                $scope.type = 'retail'
            }
            $scope.init = function(){
                $http({method: 'GET', url: $scope.urlLoad, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                  $scope.bills = data.bills;
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data)
                });
            }
            $scope.init();
    }])
    .controller('billDetailController', ['$scope','$http','$stateParams','$location', function($scope,$http,$stateParams,$location) {
            console.log('load bill detail');
            $scope.url = config.base + '/bill_detail?id=' + $stateParams.id;
            $scope.init = function(){
                $http({method: 'GET', url: $scope.url, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                  $scope.bill = data.bill;
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data)
                });
            }
            $scope.init();
            $scope.backToList = function(){
                $location.path('bill/' + $stateParams.type);
            }
    }])

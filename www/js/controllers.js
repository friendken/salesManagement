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
                  console.log(data);
                });
        };
        $scope.init();
        
        $scope.editProduct = function(el){
            $scope.changeView('edit','cancel',el.item.id);
        };
        $scope.deleteProductType = function(){
            if(!confirm('Bạn chắc chứ?'))
                return false;
            $http({method: 'GET', url: config.base + '/product_type/deleteType?id=' + this.item.id, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.init();
                }).
                error(function(data, status) {
                    console.log(data);
                });
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
                  console.log(data);
                });
        };
        $scope.cancelProduct = function(el){
            $scope.changeView('cancel','edit',el.item.id);
        };
        $scope.changeView = function(show,hide,id){
            $('#' + show + '_name_' + id).hide();
            $('#' + hide + '_name_' + id).show();   
            $('#' + show + '_btn_' + id).hide();
            $('#' + hide + '_btn_' + id).show();   
        };
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
    .controller('createProductController', ['$scope','$http','showAlert','$stateParams','$location','renderSelect', function($scope,$http,showAlert,$stateParams,$location,renderSelect) {
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
                    $scope.product_type = data.product_type;
                    renderSelect.initDataSelect(data.product_type,'#product-type');
                    renderSelect.initSelect();
                    $scope.product.product_type = data.product_type[0];
                    $scope.product.sale_price = [{id:1, name: '',quantity: '',price: '',parent_name: ''}];
                    if(data.products){
                         $scope.product = data.products;
                         var position = parseInt(data.products.sale_price.length) - 1;
                         $('#btn_more_price').data('id',data.products.sale_price[position].id);
                     }
                    
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init();
        $scope.morePrice = function (){
            var tr_id = $('#btn_more_price').data('id');
            var template = $('#tr_product_price_' + tr_id);
            var unit = template.children('td:nth-child(3)').children().val();
            if(unit.trim() === ''){
                template.children('td:nth-child(3)').children().addClass('error');
                return false;
            }
            template.children('td:nth-child(3)').children().removeClass('error');
            var new_id = parseInt(tr_id) + 1;
            $('#btn_more_price').data('id',new_id);
            $('.list_product_price').append('<tr class="product_price" id="tr_product_price_' + new_id +'">' + template.html() + '</tr>');
            var new_template = $('#tr_product_price_' + new_id);
            $('#tr_product_price_' + new_id + ' input').val('');
            $('#tr_product_price_' + new_id).children('td:nth-child(5)').html('');
            new_template.children('td:nth-child(1)').text(unit + ' =');
        };
        $scope.createProduct = function (){
            var list_price = new Array();
            $('.product_price').each(function(){
                if($(this).children('td:nth-child(2)').children().val() != '')
                    list_price.push([{quantity: $(this).children('td:nth-child(2)').children().val()},
                                    {name: $(this).children('td:nth-child(3)').children().val()},
                                    {price: $(this).children('td:nth-child(4)').children().val()}]);
            });

            if(list_price.length == 0)
                return false;

            $scope.product.sale_price = list_price;
            var product = {name: $scope.product.name,
                           code: $scope.product.code,
                           description: $scope.product.description,
                           product_type: $scope.product.product_type,
                           list_price: $scope.product.sale_price};

            $http({method: 'post', url: $scope.urlSave,
               data: product, reponseType: 'json'}).
               success(function(data, status) {
                   showAlert.showSuccess(3000,'lưu thành công');
                   $location.path('product');
               }).
               error(function(data, status) {
                 console.log(data);
               });
        };
    }])
    .controller('productController', ['$scope','$http','renderSelect', function($scope,$http,renderSelect) {
            console.log('load product list');
            $scope.init = function(){
                $http({method: 'GET', url: config.base + '/products', reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                        $scope.products = data.products;
                        renderSelect.initDataSelect(data.product_type,'#filter_product_type');
                        renderSelect.initSelect();
                        
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init();
            $scope.deleteProduct = function ($event){
                if(!confirm('bạn chắc chứ?'))
                    return false;
                $http({method: 'GET', url: config.base + '/products/deleteProduct?id=' + $($event.currentTarget).attr('id'), reponseType: 'json'}).
                    success(function(data, status) {
                        $scope.init();
                    }).
                    error(function(data, status) {
                        console.log(data);
                    });
            }
    }])
    .controller('warehouseWholesaleController', ['$scope','$http','$stateParams','showAlert','$location','renderSelect', function($scope,$http,$stateParams,showAlert,$location, renderSelect) {
            console.log('load warehouse-wholesale');
            if($stateParams.type === 'wholesale'){
                $scope.url = config.base + '/warehouse_wholesale/saveAddWholesale';
                $scope.warehouse_type = 'Sỉ';
                $scope.warehouse_type_en = 'wholesale'
            }
            else{
                $scope.url = config.base + '/warehouse_retail/saveAddRetail';
                $scope.warehouse_type = 'Lẻ';
                $scope.warehouse_type_en = 'retail'
            }
            $scope.wholesale = {};
            $scope.wholesale.partner = 1;
            $scope.wholesale.total_bill = 0;
            $scope.show_total_bill = 0;
            $scope.init = function(){
                $http({method: 'GET', url: config.base + '/warehouse_wholesale/addWholesale', reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                        renderSelect.initDataSelect(data.customers,'#invoice-customer');
                        renderSelect.initDataSelect(data.products,'#tr_product_buy_price_1 select.load_product');
                        renderSelect.initSelect();

                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init();
            
            $scope.moreBuy = function(){
                //get template and new tr_id
                var tr_id = $('.btn_more_buy').data('id');
                var template = $('#tr_product_buy_price_' + tr_id);
                var quantity = template.children('td:nth-child(4)').children().val().trim();
                var price = template.children('td:nth-child(6)').children().val().trim();
                if(quantity === '' || isNaN(quantity))
                    return false;
                if(price === '' || isNaN(price))
                    return false;
                
                var new_id = tr_id + 1;
                $('.btn_more_buy').data('id',new_id);
                
                
                
                //get select product and clone it
                var select = $('#tr_product_buy_price_' + tr_id + ' select').html();
                select = '<select data-placeholder="sản phẩm" onchange="loadUnitProduct(this)" class="chzn-select">' + select +'</select>';
                
                //get select unit prodcut and clone it
                var select_unit = $('#tr_product_buy_price_' + tr_id + ' select.load_unit').html();
                select_unit = '<select data-placeholder="sản phẩm" class="chzn-select">' + select_unit +'</select>';
                
                //clone template and remove date
                template.after('<tr class="product_buy_price" id="tr_product_buy_price_' + new_id +'">' + template.html() + '</tr>');
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(3)').html(select);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(2)').text(new_id);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(5)').html(select_unit);
                $('#tr_product_buy_price_' + new_id + ' div.iconBox').remove();
                $('#tr_product_buy_price_' + new_id).data('id', new_id);
                
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').prop('id','show_bill_product_' + new_id);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').prop('id','txt_hide_' + new_id);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').html('');
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').val(0);
                renderSelect.initSelect();
            };
            $scope.checkBill = function(){
                if($('#actual_warehouse').val().replace(/,/ig,'') == 0){
                    $scope.wholesale.debt = 0;
                    $('#debt_warehouse').val(0);
                    return false;
                }

                $scope.wholesale.actual = parseInt($('#actual_warehouse').val().replace(/,/ig,''));
                $('#actual_warehouse').val(numeral($('#actual_warehouse').val()).format('0,0'));


                $scope.wholesale.debt = parseInt($('#txt_hide_total_bill').val()) - parseInt($scope.wholesale.actual);
                $('#debt_warehouse').val(numeral($scope.wholesale.debt).format('0,0'));
            };
            $scope.addWhole = function(){
                var buy_price = new Array();
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(4)').children('input').val().trim() !== '' || $(this).children('td:nth-child(6)').children('input').val().trim() !== ''){
                       buy_price.push({product_id: $(this).children('td:nth-child(3)').children('select').val(),
                                        quantity: $(this).children('td:nth-child(4)').children('input').val(),
                                        unit: $(this).children('td:nth-child(5)').children('select').val(),
                                        price: $(this).children('td:nth-child(7)').children('input').val()}); 
                   };
                });
                
                if(buy_price.length === 0){
                    alert('vui lòng nhập sản phẩn vào kho');
                    return false;
                } 
                $scope.wholesale.buy_price = buy_price;
                $scope.wholesale.total_bill = $('#txt_hide_total_bill').val();
                
                //======= send request =======
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            showAlert.showSuccess(3000,'lưu thành công');
                            if($stateParams.type === 'wholesale')
                                $location.path('warehouse-divide/' + data);
                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                
            };
    }])
    .controller('warehouseController', ['$scope','$http','$stateParams', function($scope,$http,$stateParams) {
                console.log('load warehouse');
                if ($stateParams.type === 'wholesale'){
                    $scope.urlLoad = config.base + '/warehouse_wholesale';
                    $scope.product_name_type = 'sỉ';
                }else{
                    $scope.urlLoad = config.base + '/warehouse_retail';
                    $scope.product_name_type = 'lẻ';
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
                      console.log(data);
                    });
                };
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
                  console.log(data);
                });
            };
            $scope.init();
            $scope.transfer = function(el){
                var quantity = $('#quantity_transfer_' + el.item.product_id).val();
                if(quantity === '' || isNaN(quantity)){
                    $('#quantity_transfer_' + el.item.product_id).addClass('error');
                    alert('vui lòng kiểm tra lại số lượng nhập');
                    return false;
                }
                if(parseInt(quantity) > parseInt(el.item.quantity)){
                    $('#quantity_transfer_' + el.item.product_id).addClass('error');
                    alert('số lượng trong kho không đủ để chuyển');
                    return false;
                }
                $('#quantity_transfer_' + el.item.product_id).removeClass('error');
                if(confirm('bạn có chắc muốn chuyển ' + quantity + ' ' + el.item.unit_name + ' ' + el.item.name)){
                    $http({method: 'post', url: config.base + '/stock_transfer/doTransfer',
                        data: {product_id: el.item.product_id,quantity: quantity}, reponseType: 'json'}).
                        success(function(data, status) {
                            showAlert.showSuccess(3000,'chuyển thành công');
                            $scope.init();

                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                }
            };
        }])
        .controller('warehouseSaleController', ['$scope','$http','$stateParams','showAlert','renderSelect', function($scope,$http,$stateParams,showAlert,renderSelect) {
            console.log('load warehouse-sale');
            if($stateParams.type === 'wholesale'){
                $scope.url = config.base + '/warehouse_wholesale_sale/createBill';
                $scope.load_product = config.base + '/warehouse_wholesale';
                $scope.warehouse_type = 'sỉ';
                $scope.warehouse_type_en = 'wholesale';
            }
            else{
                $scope.url = config.base + '/warehouse_retail_sale/createBill';
                $scope.load_product = config.base + '/warehouse_retail';
                $scope.warehouse_type = 'lẻ';
                $scope.warehouse_type_en = 'retail';
            }
            $scope.wholesale = {};
            $scope.show_customer = new Array();
            $scope.wholesale.partner = 1;
            $scope.wholesale.total_bill = 0;
            $scope.show_total_bill = 0;
            $scope.init = function(){
                $http({method: 'GET', url: $scope.load_product, reponseType: 'json'}).
                    success(function(data, status) {
                        $scope.data_customer = data.customers;
                        renderSelect.initDataSelect(data.customers,'#sale-customer');
                        renderSelect.initDataSelect(data.products,'#tr_product_buy_price_1 select.load_product',true);
                        renderSelect.initSelect();
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init();
            $scope.selectCustomer = function(){
                console.log($scope.wholesale.partner);
                $scope.data_customer.forEach(function(customer){
                    if(customer.id == $scope.wholesale.partner){
                        $scope.show_customer = customer;
                        return false;
                    }
                })
            }
            $scope.moreBuy = function(){
                //get template and new tr_id
                var tr_id = $('.btn_more_buy').data('id');
                var template = $('#tr_product_buy_price_' + tr_id);
                var quantity = template.children('td:nth-child(4)').children().val().trim();
                var price = template.children('td:nth-child(6)').children().val().trim();
                if(quantity === '' || isNaN(quantity))
                    return false;
                if(price === '' || isNaN(price))
                    return false;
                
                var new_id = tr_id + 1;
                $('.btn_more_buy').data('id',new_id);
                
                
                
                //get select product and clone it
                var select = $('#tr_product_buy_price_' + tr_id + ' select').html();
                select = '<select data-placeholder="sản phẩm" onchange="loadUnitProduct(this,true)" class="chzn-select">' + select +'</select>';
                
                //get select unit prodcut and clone it
                var select_unit = $('#tr_product_buy_price_' + tr_id + ' select.load_unit').html();
                select_unit = '<select data-placeholder="sản phẩm" class="chzn-select">' + select_unit +'</select>';
                
                //clone template and remove date
                template.after('<tr class="product_buy_price" id="tr_product_buy_price_' + new_id +'">' + template.html() + '</tr>');
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(3)').html(select);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(2)').text(new_id);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(5)').html(select_unit);
                $('#tr_product_buy_price_' + new_id + ' div.iconBox').remove();
                $('#tr_product_buy_price_' + new_id).data('id', new_id);
                
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').prop('id','show_bill_product_' + new_id);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').prop('id','txt_hide_' + new_id);
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('span').html('');
                $('#tr_product_buy_price_' + new_id).children('td:nth-child(7)').children('input').val(0);
                renderSelect.initSelect();
            };
            $scope.checkBill = function($event){
                if($('#actual_warehouse').val().replace(/,/ig,'') == 0){
                    $scope.wholesale.debt = 0;
                    $('#debt_warehouse').val(0);
                    return false;
                }

                $scope.wholesale.actual = parseInt($('#actual_warehouse').val().replace(/,/ig,''));
                $('#actual_warehouse').val(numeral($('#actual_warehouse').val()).format('0,0'));


                $scope.wholesale.debt = parseInt($('#txt_hide_total_bill').val()) - parseInt($scope.wholesale.actual);
                $('#debt_warehouse').val(numeral($scope.wholesale.debt).format('0,0'));
            };
            $scope.createBill = function(){
                
                var buy_price = new Array();
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(4)').children('input').val().trim() !== '' || $(this).children('td:nth-child(6)').children('input').val().trim() !== ''){
                       buy_price.push({product_id: $(this).children('td:nth-child(3)').children('select').val(),
                                        quantity: $(this).children('td:nth-child(4)').children('input').val(),
                                        unit: $(this).children('td:nth-child(5)').children('select').val(),
                                        price: $(this).children('td:nth-child(7)').children('input').val()}); 
                   };
                });
                
                if(buy_price.length === 0){
                    alert('vui lòng chọn sản phẩm bán');
                    return false;
                } 
                $scope.wholesale.buy_price = buy_price;
                $scope.wholesale.total_bill = $('#txt_hide_total_bill').val();
                
                //======= send request =======
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            console.log(data);
                            showAlert.showSuccess(3000,'lưu thành công');
//                            $location.path('product');
                        }).
                        error(function(data, status) {
                          console.log(data);
                        });
                
            };
    }])
    .controller('billController', ['$scope','$http','$stateParams', function($scope,$http,$stateParams) {
            console.log('load bill');
            if ($stateParams.type === 'wholesale'){
                $scope.urlLoad = config.base + '/warehouse_wholesale_sale';
                $scope.product_name_type = 'sỉ';
                $scope.type = 'wholesale';
            }else{
                $scope.urlLoad = config.base + '/warehouse_retail_sale';
                $scope.product_name_type = 'lẻ';
                $scope.type = 'retail';
            }
            $scope.init = function(){
                $http({method: 'GET', url: $scope.urlLoad, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                  $scope.bills = data.bills;
//                    $('#tabel_product_type').dataTable();
                }).
                error(function(data, status) {
                  console.log(data);
                });
            };
            $scope.init();
    }])
    .controller('billDetailController', ['$scope','$http','$stateParams','$location', function($scope,$http,$stateParams,$location) {
            console.log('load bill detail');
            $scope.url = config.base + '/bill_detail?id=' + $stateParams.id + '&type=' + $stateParams.type;
            $scope.init = function(){
                $http({method: 'GET', url: $scope.url, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                  $scope.bill = data.bill;
                }).
                error(function(data, status) {
                  console.log(data);
                });
            };
            $scope.init();
            $scope.backToList = function(){
                $location.path('bill/' + $stateParams.type);
            };
    }])
    .controller('warehouseDivideController', ['$scope','$http','$stateParams','$location', function($scope,$http,$stateParams,$location) {
                console.log('load warehouse divide');
                $scope.url = config.base + '/warehouse_divide?id=' + $stateParams.warehousing_id;
                $scope.init = function(){
                    $http({method: 'GET', url: $scope.url, reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                      if(data.warehousing.allow == 1){
                          window.location = config.base + '/dashboard/page404';
                          return false;
                      }
                      $scope.renderTable(data.products, data.warehouses);

                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
                };
                $scope.renderTable = function (products, warehouses){
                    var html = '';
                    for(var x in products){
                        html += '<tr>';
                        html += '<td>' + products[x].stt + '</td>';
                        html += '<td>' + products[x].detail.name + '</td>';
                        html += '<td id="product_quantity_' + products[x].product_id + '">' + products[x].quantity + '</td>';
                        html += '<td>' + products[x].unit.name + '</td>';
                        html += '<td align="left">';
                        html += '<div>';
                        html += '<span><lable>Kho nhà </label></span>';
                        html += '<span><input type="text" data-product-id="' + products[x].product_id + '" data-warehouse-id="0" id="warehouse_' + products[x].product_id + '" value="' + products[x].quantity + '"/></span>';
                        html += '</div>';
                        for(var y in warehouses){
                            html += '<div>';
                            html += '<span><lable>' + warehouses[y].name + '</label></span>';
                            html += '<span><input class="storge_product_' + products[x].product_id + '" onkeyup="dividedQuantity(this)" data-product-id="' + products[x].product_id + '" data-warehouse-id="' + warehouses[y].id + ' "type="text" /></span>';
                            html += '</div>';
                        }
                        html += '</td>';
                        html += '</tr>';
                    }
                    $('#list-product-divide').html(html);
                };
                $scope.init();
                $scope.divideWarehouse = function(){
                    var list = new Array();
                    $('input').each(function(){
                        var product_id = $(this).data('product-id'),
                            warehouse_id = $(this).data('warehouse-id');
                        if(list[warehouse_id])
                            list[warehouse_id].push({product_id: product_id,quantity: this.value});
                        else
                            list[warehouse_id] = new Array({product_id: product_id,quantity: this.value});
                    });
                    $http({method: 'POST', url: config.base + '/warehouse_divide/updateStorge',data: {list: list,warehousing_id: $stateParams.warehousing_id}, reponseType: 'json'}).
                    success(function(data, status) {
                        $location.path('product');
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
                };
    }])
    .controller('warehouseListController', ['$scope', '$http', '$location', '$modal', function($scope, $http, $location, $modal) {
                console.log('load warehouse list');
                $scope.openPopup = function(size,$event){
                    if($event)
                        var warehouses_id = $($event.currentTarget).data('id');
                    
                    var modalInstance = $modal.open({
                        templateUrl: 'createWarehouse.html',
                        controller: 'ModalInstanceCtrl',
                        size: size,
                        resolve: {
                          items: function () {
                            return warehouses_id;
                          }
                        }
                    });
                    modalInstance.result.then(function () {
                        $scope.init();
                    });
                };
                $scope.url = config.base + '/warehouses';
                $scope.init = function(){
                    $http({method: 'GET', url: $scope.url, reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                      console.log(data);
                      $scope.warehouses = data.warehouses;
    
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
                };
                $scope.init();
//                $scope.backToList = function(){
//                    $location.path('bill/' + $stateParams.type);
//                }
    }])
    .controller('ModalInstanceCtrl', function ($scope,$http, $modalInstance, items) {
            $scope.warehouse = {};
            if(items){
                $http({method: 'GET', url: config.base + '/warehouses/getWarehouse/' + items, reponseType: 'json'}).
                    success(function(data, status) {
                      //==== get data account profile ========
                      console.log(data);
                      $scope.warehouse = data.warehouse;
    
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            }

    
        $scope.ok = function () {
            console.log($scope.warehouse);
            $http({method: 'POST', url: config.base + '/warehouses/addWarehouse',data: $scope.warehouse, reponseType: 'json'}).
                    success(function(data, status) {
                      $modalInstance.close(data);
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
        };

        $scope.cancel = function () {
          $modalInstance.dismiss('cancel');
        };
    })
    .controller('warehouseStatusController', ['$scope','$http', function($scope,$http) {
            console.log('load tình trạng kho');
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/warehouses/getAllWarehouses', reponseType: 'json'}).
                success(function(data, status) {
                    var html_select = '';
                    for(var x in data.products){
                        html_select += '<option value="' + data.products[x].id + '">' + data.products[x].name + '</option>';
                    }
                    $('#filter_product_type').append(html_select);
                    $scope.initSelect();
                    $scope.warehouses = data.warehouses;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init();
        $scope.initSelect = function (){
            $('select').not("select.chzn-select,select[multiple],select#box1Storage,select#box2Storage").selectmenu({
                style: 'dropdown',
                transferClasses: true,
                width: null
            });

            $(".chzn-select").chosen(); 
        };
         
    }])
    .controller('warehouseOutOfStorgeController', ['$scope','$http', function($scope,$http) {
            console.log('load tình trạng kho');
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/warehouses/getProductOutOfStorge', reponseType: 'json'}).
                success(function(data, status) {
                  $scope.products = data.products;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
    }])
    .controller('totalLiabilityController', ['$scope','$http', function($scope,$http) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/debit/totalLiability', reponseType: 'json'}).
                success(function(data, status) {
                  $scope.bill = data.bill;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
    }])
    .controller('totalDebitController', ['$scope','$http','$stateParams', function($scope,$http,$stateParams) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/debit/totalDebit', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.bill = data.bill;
                    if($stateParams.customer_id){
                        data.bill.forEach(function(item){
                            if(item.customer_id == $stateParams.customer_id){
                                $scope.searchBill = item.customer_name;
                                return false;
                            }
                        });
                    }
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
    }])
    .controller('warehousingHistoryController', ['$scope','$http', function($scope,$http) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/history/warehousingHistory', reponseType: 'json'}).
                success(function(data, status) {
                  $scope.history = data.history;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
    }])
    .controller('warehousingDetailController', ['$scope','$http','$stateParams', function($scope, $http, $stateParams) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/debit/warehousingDetail?id=' + $stateParams.id, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.bill = data.bill;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
    }])
    .controller('warehousesTransferController', ['$scope','$http', function($scope, $http) {
        $scope.transferList = new Array();
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/stock_transfer/initWarehousesTransfer' , reponseType: 'json'}).
                success(function(data, status) {
                    var html_select = '';
                    for(var x in data.warehouses){
                        html_select += '<option value="' + data.warehouses[x].id + '">' + data.warehouses[x].name + '</option>';
                    }
                    $('.warehouses_list').html(html_select);
                    $scope.initSelect();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
        $scope.initSelect = function (){
            $('select').not("select.chzn-select,select[multiple],select#box1Storage,select#box2Storage").selectmenu({
                style: 'dropdown',
                transferClasses: true,
                width: null
            });

            $(".chzn-select").chosen(); 
        };
        $scope.selectWarehouseFrom = function(){
            $http({method: 'GET', url: config.base + '/warehouses/getWarehouseStorge?id=' + $scope.warehouse_from, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.data_from = data.warehouses;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.selectWarehouseTo = function(){
            $http({method: 'GET', url: config.base + '/warehouses/getWarehouseStorge?id=' + $scope.warehouse_to, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.data_to = data.warehouses;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.doTransfer = function($event){
            var product_id = $($event.currentTarget).data('product-id'),
                quantity = parseInt($('#quanity_product_' + product_id).text()),
                value = parseInt($('#quantity_transfer_' + product_id).val().trim()),
                product_name = $($event.currentTarget).data('product-name'),
                unit = $($event.currentTarget).data('unit');
            
            if(value > quantity){
                alert("không đủ số lượng");
                return false;
            }
            if(isNaN(value)){
                alert("số lượng phải là số");
                return false;
            }
            $scope.transferList.push({remaining: (quantity - value),product_id: product_id, quantity: value, product_name: product_name, unit: unit});
            $('#quanity_product_' + product_id).text(quantity - value);
        };
        $scope.saveTransfer = function(){
            if(!$scope.warehouse_to){
                alert('vui lòng chọn kho muốn chuyển');
                return false;
            }
            if($scope.transferList.length === 0){
                alert('vui lòng chọn sản phẩm');
                return false;
            }
            if($scope.warehouse_from == $scope.warehouse_to){
                alert('bạn không thể chuyển sản phẩm trong cùng một kho');
                return false;
            }
            $http({method: 'POST', url: config.base + '/stock_transfer/saveWarehouseTransfer' , data: {warehouse_from: $scope.warehouse_from, warehouse_to: $scope.warehouse_to, transfer: $scope.transferList},reponseType: 'json'}).
                success(function(data, status) {
                    $scope.selectWarehouseTo();
                    $scope.selectWarehouseFrom();
                    $scope.transferList = new Array();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
    }])
    .controller('warehousesExportController', ['$scope','$http', function($scope, $http) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/stock_transfer/getExport', reponseType: 'json'}).
                success(function(data, status) {
                  $scope.exports = data.export;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
    }])
    .controller('exportDetailController', ['$scope','$http','$stateParams','$location', function($scope, $http, $stateParams, $location) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/stock_transfer/getExportDetail?id=' + $stateParams.id, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.exports = data.exports;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
        $scope.backToList = function(){
            $location.path('warehouses-export');
        };
    }])
    .controller('customersController', ['$scope','$http','$stateParams','$modal', function($scope, $http, $stateParams, $modal) {
        $scope.customer_type = $stateParams.type;
            if($stateParams.type === 'partner')
                $scope.customer_name = 'Đối tác';
            else
                $scope.customer_name = 'Khách hàng';
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/customers?type=' + $stateParams.type, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.customers = data.customers;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init();
        $scope.deleteCustomer = function($event){
            if(!confirm('bạn chắc chứ?'))
                return false;
            $http({method: 'GET', url: config.base + '/customers/deleteCustomer?id=' + $($event.currentTarget).attr('id'), reponseType: 'json'}).
                success(function(data, status) {
					$scope.init();
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.openPopup = function(size,$event){
            if($event)
                var customer_id = $($event.currentTarget).data('id');
            var modalInstance = $modal.open({
                templateUrl: 'create_customer',
                controller: 'createCustomerController',
                size: size,
                resolve: {
                  items: function () {
                    return {type: $stateParams.type, customer_id: customer_id};
                  }
                }
            });
            modalInstance.result.then(function () {
                $scope.init();
            });
        };
    }])
    .controller('createCustomerController', function ($scope,$http, $modalInstance, items) {
            $scope.customer = {};
            $scope.customer.type = items.type;
            if(items.type === 'partner')
                $scope.customer_name = 'Đối tác';
            else
                $scope.customer_name = 'Khách hàng';
            if(items.customer_id){
                $http({method: 'GET', url: config.base + '/customers/getCustomer?id=' + items.customer_id, reponseType: 'json'}).
                    success(function(data, status) {
                      $scope.customer = data.customer;
    
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            }

        $scope.morePhone = function($event){
            var table = $($event.currentTarget).closest('table').data('class');
            var html = '<tr><td><input type="text" class="' + table.substr(5) + '"/></td><td></td></td></tr>';
            $('.' + table).append(html);
        }
        $scope.ok = function () {
            if(items.customer_id)
                var url = config.base + '/customers/editCustomer?id=' + items.customer_id;
            else
                var url = config.base + '/customers/createCustomer';

            //get phone home and phone mobile
            var phone_home = new Array();
            $('.phone_home').each(function(){
                if(this.value != '' && !isNaN(this.value))
                    phone_home.push(this.value);
            })
            var phone_mobile = new Array();
            $('.phone_mobile').each(function(){
                if(this.value != '' && !isNaN(this.value))
                    phone_mobile.push(this.value);
            })
            $scope.customer.phone_home = phone_home;
            $scope.customer.phone_mobile = phone_mobile;

            $http({method: 'POST', url: url,data: $scope.customer, reponseType: 'json'}).
                    success(function(data, status) {
                      $modalInstance.close(data);
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
        };

        $scope.cancel = function () {
          $modalInstance.dismiss('cancel');
        };
    })
    .controller('createOrderController', ['$scope','$http','$location','showAlert','renderSelect', function($scope, $http, $location, showAlert, renderSelect) {
        $scope.order = {};
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/order/createOrder?type=customer', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.customers = data.customers;
                    $scope.products = data.products;
                    $scope.units = data.units;
                    renderSelect.initDataSelect(data.customers,'#sl_customer');
                    renderSelect.initDataSelect(data.products,'#tr_order_1 select.load_product');
                    renderSelect.initSelect();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
        $scope.selectCustomer = function (){
            for(var x in $scope.customers){
                if($scope.customers[x].id === $scope.order.customer_id){
                    $scope.address_store = $scope.customers[x].address;
					$scope.phone_mobile = $scope.customers[x].phone_mobile;
					$scope.phone_home = $scope.customers[x].phone_home;
                    $scope.total_debt = $scope.customers[x].total_debt.debt;
                    $scope.customer_id = $scope.customers[x].id;
                    break
                }
            }
        };
        
        $scope.selectProduct = function(){
            var target_id = $(event.currentTarget).closest('tr').data('id');
            $scope.products.forEach(function(product){
                if(product.id === $('#tr_order_' + target_id).children('td:nth-child(3)').children('select.load_product').val()){
                    $('#tr_order_' + target_id + ' td:nth-child(5)').html('<select data-placeholder="chọn quy cách" ng-model="select_unit" onchange="angular.element(this).scope().selectUnit()" class="chzn-select load_unit"></select>');
                    renderSelect.initDataSelect(product.sale_price,'#tr_order_' + target_id + ' select.load_unit');
                    $('#tr_order_' + target_id).children('td:nth-child(4)').children('input.show_buy').val(numeral(parseInt(product.buy_price[0].price) / parseInt(product.buy_price[0].quantity)).format('0,0'));
                    $('#tr_order_' + target_id).children('td:nth-child(4)').children('input.show_buy_origin').val(product.buy_price[0].id);
                    renderSelect.initSelect();
                    return false;
                }
            });
            console.log(target_id);
        };
        $scope.selectUnit = function(){
            var target_id = $(event.currentTarget).closest('tr').data('id');
            $scope.units.forEach(function(unit){
                if(unit.id === $('#tr_order_' + target_id).children('td:nth-child(5)').children('select.load_unit').val()){
                    $('#tr_order_' + target_id).children('td:nth-child(6)').children('input.show_sale').val(numeral(parseInt(unit.price)).format('0,0'));
                    $('#tr_order_' + target_id).children('td:nth-child(6)').children('input.show_sale_origin').val(unit.price);
                    $('#tr_order_' + target_id).children('td:nth-child(6)').children('input.show_sale_origin').attr('data-sale-id',unit.id);
                }
            });
            console.log(target_id);
        };
        $scope.calculatorPrice = function(){
            var target_id = $(event.currentTarget).closest('tr').data('id'),
                quantity = parseInt($(event.currentTarget).val()),
                price = parseInt($('#tr_order_' + target_id).children('td:nth-child(6)').children('input.show_sale_origin').val());
                
            if(isNaN(quantity)){
                quantity = 0;
                $('#tr_order_' + target_id).children('td:nth-child(8)').children('span').html('');
            }
            var format_price = numeral(quantity * price).format('0,0');
            $('#tr_order_' + target_id).children('td:nth-child(8)').children('span').html('<h5>' + format_price + '</h5>');
            $('#tr_order_' + target_id).children('td:nth-child(8)').children('input').val(quantity * price);
            var total_order = 0;
            $('.price_order').each(function(){
                total_order += parseInt(this.value);
            });
            $('#total_order').html(numeral(total_order).format('0,0'));
            $('#txt_hide_total_bill').val(total_order);
        };
        $scope.moreOrder = function(){
            var tr_id = parseInt($('.btn_more_order').data('id')),
                new_id = tr_id + 1,
                template = $('#tr_order_' + tr_id);
            $('.btn_more_order').data('id',new_id);
            template.after('<tr class="product_order" data-id="'+ new_id +'" id="tr_order_' + new_id + '">' + template.html() + '<tr>');
            $('#tr_order_' + new_id + ' td:nth-child(3)').html('<select data-placeholder="sản phẩm" ng-model="select_product" onchange="angular.element(this).scope().selectProduct()" class="chzn-select load_product"></select>');
            renderSelect.initDataSelect($scope.products,'#tr_order_' + new_id + ' select.load_product');
            $('#tr_order_' + new_id + ' td:nth-child(1)').html('');
            $('#tr_order_' + new_id + ' td:nth-child(7)').html('<input style="width: 50px" ng-model="quantity" onkeyup="angular.element(this).scope().calculatorPrice()" type="text"/>');
            $('#tr_order_' + new_id + ' td:nth-child(2)').html(new_id);
            renderSelect.initSelect();
        };
        $scope.saveOrder = function(){
            var orders = new Array();
            $('.product_order').each(function(){
                var order = {product_id: $(this).children('td:nth-child(3)').children('select').val(),
                             cost: $(this).children('td:nth-child(4)').children('.show_buy_origin').val(),
                             unit: $(this).children('td:nth-child(5)').children('select').val(),
                             price: $(this).children('td:nth-child(6)').children('.show_sale_origin').val(),
                             quantity: $(this).children('td:nth-child(7)').children('input').val(),
                             total: $(this).children('td:nth-child(8)').children('.price_order').val()};
                orders.push(order);
            });
            $scope.order.orders = orders;
            $scope.order.total_price = $('#txt_hide_total_bill').val();
            //send request
            $http({method: 'POST', url: config.base + '/order/addOrder',data: $scope.order, reponseType: 'json'}).
            success(function(data, status) {
                showAlert.showSuccess(3000,'lưu thành công');
				$location.path('order-management');
            }).
            error(function(data, status) {
              console.log(data);
            });
        };
    }])
    .controller('managementOrderController', ['$scope','$http','showAlert','$location','renderSelect', function($scope, $http, showAlert, $location, renderSelect) {
        $scope.orders = new Array();
        $scope.shipments = new Array();
        $scope.date = new Date();
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/order/managementOrder', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.orders = data.orders;
                    var staff = new Array({id: 1, name: 9874},{id: 9, name: 4569});
                    renderSelect.initDataSelect(staff, '#order-truck-manager');
                    renderSelect.initSelect();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init();
        $scope.selectOrder = function ($event, back){
            var order_id = $($event.currentTarget).data('id');
            if(back){
                for(var x in $scope.shipments){
                    if($scope.shipments[x].id == order_id){
                        $scope.orders.push($scope.shipments[x]);
                        $scope.shipments.splice(x,1);
                        break;
                    }
                }
                
            }else{
                for(var x in $scope.orders){
                    if($scope.orders[x].id == order_id){
                        $scope.shipments.push($scope.orders[x]);
                        $scope.orders.splice(x,1);
                        break;
                    }
                }
            }
        };
        $scope.selectTruck = function(){
            $http({method: 'GET', url: config.base + '/order/getRestOrder?truck_id=' + $scope.order.truck,data: $scope.order, reponseType: 'json'}).
            success(function(data, status) {
                if($scope.shipments.length == 0)
                    $scope.shipments = data.orders;
                else{
                    if(data.orders.length != 0)
                        $scope.shipments.push(data.orders)
                }
            }).
            error(function(data, status) {
              console.log(data);
            });
        };
        $scope.divideProduct = function (){
            $scope.order.shipments = $scope.shipments;
            
            //send request
            $http({method: 'POST', url: config.base + '/order/createShipment',data: $scope.order, reponseType: 'json'}).
            success(function(data, status) {
                showAlert.showSuccess(3000,'lưu thành công');
                $location.path('order-divide/' + data.shipment_id);
            }).
            error(function(data, status) {
              console.log(data);
            });
            
        };
    }])
    .controller('divideOrderController', ['$scope','$http', '$stateParams','showAlert','$location', function($scope, $http, $stateParams, showAlert, $location) {
            $scope.init = function (){
                $http({method: 'GET', url: config.base + '/order/divideOrder?shipment_id=' + $stateParams.shipment_id, reponseType: 'json'}).
                    success(function(data, status) {
                        if(data.shipment.allow == 1)
                            window.location = config.base + '/dashboard/page404';
                      $scope.products = data.products;
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init(); 
            $scope.quantityWarehouse = function($event){
                var value = parseInt($($event.currentTarget).val()),
                    product_id = parseInt($($event.currentTarget).data('product-id')),
                    product_quantity = parseInt($('#origin_quantity_' + product_id).val()),
                    total = 0;
                
                if(value > parseInt($($event.currentTarget).attr('placeholder'))){
                    $($event.currentTarget).val('');
                    alert('quá số lượng trong kho');
                    return false;
                }
                //get quantity all warehouse
                $('.warehouse_quantity_' + product_id).each(function(){
                    if(this.value !== '')
                        total += parseInt(this.value);
                });
                if(total > product_quantity){
                    alert('qua so luong can giao');
                    $($event.currentTarget).val('');
                    return false;
                }
                $('#show_quantity_' + product_id).text(product_quantity - total);
            };
            $scope.divideProduct = function(){
                var product = new Array;
                $('.warehouse_quantity').each(function(){
                    var quantity = $(this).val(),
                        product_id  = $(this).data('product-id'),
                        warehouse_id = $(this).data('warehouse-id');
                    if(quantity !== '')
                        product.push({product_id: product_id,warehouses_id: warehouse_id,quantity: quantity});
                });
                $http({method: 'POST', url: config.base + '/order/updateWarehouse?ship_id=' + $stateParams.shipment_id,data: product, reponseType: 'json'}).
                    success(function(data, status) {
                      showAlert.showSuccess(3000,'lưu thành công');
                      $location.path('order-management');
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
    }])
    .controller('statusOrderController', ['$scope','$http','$location','renderSelect', function($scope, $http, $location, renderSelect) {
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/order/statusOrder', reponseType: 'json'}).
                success(function(data, status) {
                  $scope.shipments = data.shipments;
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
        setTimeout(function(){
            renderSelect.initSelect();
          }, 2000);
        $scope.changeStatus = function($event){
            var shipment_id = $($event.currentTarget).data('shipment-id'),
                status = $($event.currentTarget).data('status')
            
            //change button and css
            switch(status){
                case 0:
                    $scope.updateStatusShipment(shipment_id,1);
                    break;
                case 1:
                    $scope.updateStatusShipment(shipment_id,2);
                    break;
                default:
                    break;
            }
            setTimeout(function(){ 
                renderSelect.initSelect();
            }, 2000);
        };
        
        $scope.updateStatusShipment = function (shipment_id, status){
            $http({method: 'GET', url: config.base + '/order/updateStatusShipment?shipment_id=' + shipment_id + '&status=' + status, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.init();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.handlingOrder = function($event){
            var shipment_id = $($event.currentTarget).data('shipment-id'),
                order_id = $($event.currentTarget).data('order-id'),
                status_id = $('#status_shipment_' + shipment_id + '_order_' + order_id).val(),
                price = $('#price_shipment_' + shipment_id + '_order_' + order_id).val()
            
            switch (status_id){
                case "3":
                    $scope.createBill(order_id,price, shipment_id);
                    break;
                case "4":
                    $location.path('order-return/' + order_id);
                    break;
                default:
                    $scope.updateOrder(order_id);
                    break
            }
            
        };
        $scope.createBill = function(order_id, price, shipment_id){
            $http({method: 'POST', url: config.base + '/warehouse_wholesale_sale/createBillFromOrder',data: {order_id: order_id,price: price, shipment_id: shipment_id}, reponseType: 'json'}).
                success(function(data, status) {
                  $scope.init();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.updateOrder = function(order_id){
            $http({method: 'GET', url: config.base + '/order/updateOrder?order_id=' + order_id,data: {order_id: order_id}, reponseType: 'json'}).
                success(function(data, status) {
                  console.log(data);
                }).
                error(function(data, status) {
                  console.log(data);
            });
        };
    }])
    .controller('returnOrderController', ['$scope','$http', '$stateParams','showAlert','$location', function($scope, $http, $stateParams, showAlert, $location) {
            $scope.init = function (){
                $http({method: 'GET', url: config.base + '/order/returnWarehouse?order_id=' + $stateParams.order_id, reponseType: 'json'}).
                    success(function(data, status) {
                        if(data.order.length == 0)
                            $location.path('order-status');
                        $scope.products = data.order;
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init(); 
            $scope.quantityWarehouse = function($event){
                var value = parseInt($($event.currentTarget).val()),
                    product_id = parseInt($($event.currentTarget).data('product-id')),
                    product_quantity = parseInt($('#origin_quantity_' + product_id).val()),
                    total = 0;
                console.log(value);
                console.log(product_id);
                console.log(product_quantity);
                
                //get quantity all warehouse
                $('.warehouse_quantity_' + product_id).each(function(){
                    if(this.value !== '')
                        total += parseInt(this.value);
                });
                if(total > product_quantity){
                    alert('qua so luong can giao');
                    $($event.currentTarget).val('');
                    return false;
                }
                $('#show_quantity_' + product_id).text(product_quantity - total);
            };
            $scope.divideWarehouse = function(){
                var product = new Array;
                $('.warehouse_quantity').each(function(){
                    var quantity = $(this).val(),
                        product_id  = $(this).data('product-id'),
                        warehouse_id = $(this).data('warehouse-id');
                    if(quantity !== '')
                        product.push({product_id: product_id,warehouses_id: warehouse_id,quantity: quantity});
                });
                
                $http({method: 'POST', url: config.base + '/order/getReturnWarehouse?order_id=' + $stateParams.order_id ,data: product, reponseType: 'json'}).
                    success(function(data, status) {
                        showAlert.showSuccess(3000,'lưu thành công');
                        $location.path('order-status');
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
    }])
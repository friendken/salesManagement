'use strict';

/* Controllers */

angular.module('dashboard.controllers', ['ui.bootstrap'])
    .controller('dashboardController', ['$scope', function($scope) {
        console.log('load ok');
    }])
    .controller('productTypeController', ['$scope', '$http','showAlert', function($scope,$http,showAlert) {
        
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
        $scope.printMe = function(){
            var popupWin = window.open('', '_blank', 'width=100');
            popupWin.document.open()
            popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" /></head><body onload="window.print(); window.close()"><div style="font-size:14px">' + '40000 thôi chứ nhiêu, nhưng mày hên vì có thằng bạn đẹp trai như tao =))' + '</div></html>');
            popupWin.document.close();
        }
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
        $scope.product_length
        $scope.init = function(){
            $http({method: 'GET', url: $scope.url, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.product_type = data.product_type;
                    renderSelect.initDataSelect(data.product_type,'#product-type-product_type','Loại sản phẩm');
                    renderSelect.initSelect();
                    $scope.product.product_type = data.product_type[0];
                    $scope.product.sale_price = [{id:1, name: '',quantity: '',price: '',parent_name: ''}];
                    if(data.products){
                        $scope.product = data.products;
                        $scope.product_length = data.products.length
                        renderSelect.initDataSelect(data.product_type,'#product-type-product_type','Loại sản phẩm',null,null,data.products.product_type.id);        
                    }else
                        renderSelect.initDataSelect(data.product_type,'#product-type-product_type','Loại sản phẩm');
                    renderSelect.initSelect();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init();
        $scope.morePrice = function (){
            var tr_id = $('#btn_more_price').val();
            var template = $('#tr_product_price_' + tr_id);
            var unit = template.children('td:nth-child(3)').children().val();
            if(unit.trim() === ''){
                template.children('td:nth-child(3)').children().addClass('error');
                return false;
            }
            template.children('td:nth-child(3)').children().removeClass('error');
            var new_id = parseInt(tr_id) + 1;
            $('#btn_more_price').val(new_id);
            $('.list_product_price').append('<tr class="product_price" id="tr_product_price_' + new_id +'">' + template.html() + '</tr>');
            var new_template = $('#tr_product_price_' + new_id);
            $('#tr_product_price_' + new_id + ' input').val('');
            $('#tr_product_price_' + new_id).children('td:nth(3)').html('<input type="text" onkeyup="angular.element(this).scope().formatNumber()"/>');
            $('#tr_product_price_' + new_id).children('td:nth-child(5)').html('');
            new_template.children('td:nth-child(1)').text(unit + ' =');
        };
        $scope.formatNumber = function(){
            var value = event.currentTarget.value.replace(/,/ig,'');
            $(event.currentTarget).val(numeral(event.currentTarget.value).format('0,0'));
        }
        $scope.createProduct = function (){
            var list_price = new Array();
            $('.product_price').each(function(){
                if($(this).children('td:nth-child(2)').children().val() != '')
                    list_price.push([{quantity: $(this).children('td:nth-child(2)').children().val()},
                                    {name: $(this).children('td:nth-child(3)').children().val()},
                                    {price: $(this).children('td:nth-child(4)').children().val().replace(/,/ig,'')}]);
            });

            if(list_price.length == 0)
                return false;

            $scope.product.sale_price = list_price;
            var product = {name: $scope.product.name,
                           code: $scope.product.code,
                           description: $scope.product.description,
                           product_type: $('#product-type-product_type').val(),
                           list_price: $scope.product.sale_price};

            $http({method: 'post', url: $scope.urlSave,
               data: product, reponseType: 'json'}).
               success(function(data, status) {
                   showAlert.showSuccess(3000,'Lưu thành công');
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
                        renderSelect.initDataSelect(data.product_type,'#filter_product_type','Loại sản phẩm',null,null,null,null,true);
                        renderSelect.initSelect();
                        
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init();
            $scope.deleteProduct = function ($event){
                if(!confirm('b?n ch?c ch??'))
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
                $scope.warehouse_type_en = 'wholesale';
            }
            else{
                $scope.url = config.base + '/warehouse_retail/saveAddRetail';
                $scope.warehouse_type = 'Lẻ';
                $scope.warehouse_type_en = 'retail';
            }
            $scope.wholesale = {};
            $scope.wholesale.partner = 1;
            $scope.wholesale.total_bill = 0;
            $scope.show_total_bill = 0;
            $scope.searchCustomer = '';
            $scope.show_customer = new Array();
            $scope.init = function(){
                $http({method: 'GET', url: config.base + '/warehouse_wholesale/addWholesale', reponseType: 'json'}).
                    success(function(data, status) {
                        $scope.products = data.products;
                        $scope.customers = data.customers;
                        
                        renderSelect.initDataSelect(data.products,'#tr_product_buy_price_1 select.load_product','Sản phẩm',true);
                        renderSelect.initSelect();

                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init();
            $scope.selectCustomer = function(){
                $scope.searchCustomer = '';
                $scope.show_customer = this.item;
                $scope.wholesale.partner = this.item.id;
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
                select = '<select data-placeholder="" onchange="loadUnitProduct(this)" class="chzn-select">' + select +'</select>';
                
                //get select unit prodcut and clone it
                var select_unit = $('#tr_product_buy_price_' + tr_id + ' select.load_unit').html();
                select_unit = '<select data-placeholder="" class="chzn-select">' + select_unit +'</select>';
                
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
                var product_id;
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(4)').children('input').val().trim() !== '' || $(this).children('td:nth-child(6)').children('input').val().trim() !== ''){
                       var that = this;
                       $scope.products.forEach(function(product){
                           if(product.code == $(that).children('td:nth-child(3)').children('select').val())
                               product_id = product.id;
                       })
                       buy_price.push({product_id: product_id,
                                        quantity: $(this).children('td:nth-child(4)').children('input').val(),
                                        unit: $(this).children('td:nth-child(5)').children('select').val(),
                                        price: $(this).children('td:nth-child(7)').children('input').val()}); 
                   };
                });
                
                if(buy_price.length === 0){
                    alert('Nhập sản phẩm vào kho');
                    return false;
                } 
                $scope.wholesale.buy_price = buy_price;
                $scope.wholesale.total_bill = $('#txt_hide_total_bill').val();

                // send request
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            showAlert.showSuccess(3000,'Lưu thành công');
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
                    $scope.product_name_type = 'Sỉ';
                }else{
                    $scope.urlLoad = config.base + '/warehouse_retail';
                    $scope.product_name_type = 'Lẻ';
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
        .controller('stockTransferController', ['$scope','$http','showAlert','$modal', function($scope,$http, showAlert,$modal) {
            console.log('load stock transfer');
            $scope.init = function(){
            $http({method: 'GET', url: config.base + '/stock_transfer', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.wholesale_products = data.wholesale_products;
                    $scope.retail_products = data.retail_products;
                    $scope.products = data.products;
                }).
                error(function(data, status) {
                  console.log(data);
                });
            };
            $scope.init();
            $scope.transfer = function(size,el){
                var quantity = $('#quantity_transfer_' + el.item.product_id).val();
                if(quantity === '' || isNaN(quantity)){
                    $('#quantity_transfer_' + el.item.product_id).addClass('error');
                    alert('kiểm tra sản phẩm nhập');
                    return false;
                }
                if(parseInt(quantity) > parseInt(el.item.quantity)){
                    $('#quantity_transfer_' + el.item.product_id).addClass('error');
                    alert('Lỗi');
                    return false;
                }
                var modalInstance = $modal.open({
                        templateUrl: 'check_product',
                        controller: 'checkProductCtrl',
                        size: size,
                        resolve: {
                          items: function () {
                            return {retail: $scope.retail_products,
                                    products: $scope.products,
                                    product_id: el.item.product_id,
                                    quantity: quantity};
                          }
                        }
                    });
                    modalInstance.result.then(function () {
                        $scope.init();
                    });
            };
        }])
        .controller('checkProductCtrl', function ($scope,$http, $modalInstance, items,showAlert) {
            $scope.retail_product = items.retail;
            $scope.products = items.products;
            $scope.searchProduct = '';
            $scope.search = '';
            $scope.viewTranfer = 0;
            $scope.titleLightbox = 'Kiểm tra sản phẩm';
            
            $scope.selectProduct = function(){
                if(!confirm('Chắc chứ'))
                    return false;
                $http({method: 'post', url: config.base + '/stock_transfer/doTransfer',
                    data: {send_product: items.product_id,
                           recevie_proudct: this.item.product_id,
                           quantity: items.quantity}, reponseType: 'json'}).
                    success(function(data, status) {
                        showAlert.showSuccess(3000,'Chuyển thành công');
                        $modalInstance.close();

                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            }
            $scope.addProduct = function(){
                $http({method: 'post', url: config.base + '/stock_transfer/addProductToRetail',
                    data: {send_product: items.product_id,
                           recevie_proudct: this.item.id,
                           quantity: items.quantity}, reponseType: 'json'}).
                    success(function(data, status) {
                        showAlert.showSuccess(3000,'Chuyển thành công');
                        $modalInstance.close();
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            }
            $scope.addWarehouse = function(){
                $scope.viewTranfer = 1;
                $scope.titleLightbox = 'Thêm sản phẩm vào kho';
            }
            $scope.cancel = function () {
              $modalInstance.dismiss('cancel');
            };
        })
        .controller('warehouseSaleController', ['$scope','$http','$stateParams','showAlert','renderSelect', function($scope,$http,$stateParams,showAlert,renderSelect) {
            $scope.searchCustomer = '';
            if($stateParams.type === 'wholesale'){
                $scope.url = config.base + '/warehouse_wholesale_sale/createBill';
                $scope.load_product = config.base + '/warehouse_wholesale';
                $scope.warehouse_type = 'Sỉ';
                $scope.warehouse_type_en = 'wholesale';
            }
            else{
                $scope.url = config.base + '/warehouse_retail_sale/createBill';
                $scope.load_product = config.base + '/warehouse_retail';
                $scope.warehouse_type = 'Lẻ';
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
                        $scope.products = data.products;
                        renderSelect.initDataSelect(data.products,'#tr_product_buy_price_1 select.load_product','Sản phẩm',true);
                        renderSelect.initSelect();
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init();
            $scope.selectCustomer = function(type){
                console.log(this.item)
                $scope.searchCustomer = '';
                $scope.wholesale.partner = this.item.id;
                $scope.show_customer = this.item;
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
                select_unit = '<select data-placeholder="qui cách" class="chzn-select">' + select_unit +'</select>';
                
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
                var product_id;
                $('.product_buy_price').each(function(){
                   if($(this).children('td:nth-child(4)').children('input').val().trim() !== '' || $(this).children('td:nth-child(6)').children('input').val().trim() !== ''){
                       var that = this;
                       $scope.products.forEach(function(product){
                            if(product.code == $(that).children('td:nth-child(3)').children('select').val())
                                product_id = product.product_id;
                        })
                       buy_price.push({product_id: product_id,
                                        quantity: $(this).children('td:nth-child(4)').children('input').val(),
                                        unit: $(this).children('td:nth-child(5)').children('select').val(),
                                        price: $(this).children('td:nth-child(7)').children('input').val()});
                   };
                });
                
                if(buy_price.length === 0){
                    alert('chọn sản phẩm');
                    return false;
                }

                $scope.wholesale.buy_price = buy_price;
                $scope.wholesale.total_bill = $('#txt_hide_total_bill').val();
                
                //======= send request =======
                $http({method: 'post', url: $scope.url,
                        data: $scope.wholesale, reponseType: 'json'}).
                        success(function(data, status) {
                            console.log(data);
                            showAlert.showSuccess(3000,'Lưu thành công');
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
                $scope.product_name_type = 'Sỉ';
                $scope.type = 'wholesale';
            }else{
                $scope.urlLoad = config.base + '/warehouse_retail_sale';
                $scope.product_name_type = 'Lẻ';
                $scope.type = 'retail';
            }
            $scope.init = function(){
                $http({method: 'GET', url: $scope.urlLoad, reponseType: 'json'}).
                success(function(data, status) {
                  //==== get data account profile ========
                  $scope.bills = data.bills;

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
                        html += '<td style="width: 300px">';
                        html += '<div style="padding: 15px; width: 170px; margin-bottom: 10px">';
                        html += '<div style="float: left;">Kho nhà </div>';
                        html += '<div style="float: right; position: absolute"><input style="margin: -10px 0px 0px 100px;width: 60px" type="text" data-product-id="' + products[x].product_id + '" data-warehouse-id="0" id="warehouse_' + products[x].product_id + '" value="' + products[x].quantity + '"/></div>';
                        html += '</div>';
                        for(var y in warehouses){
                            html += '<div style="padding: 15px; width: 170px; margin-bottom: 10px">';
                            html += '<div style="float: left;">' + warehouses[y].name + '</div>';
                            html += '<div style="float: right; position: absolute"><input style="margin: -10px 0px 0px 100px;width: 60px" class="storge_product_' + products[x].product_id + '" onkeyup="dividedQuantity(this)" data-product-id="' + products[x].product_id + '" data-warehouse-id="' + warehouses[y].id + ' "type="text" /></div>';
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
    .controller('warehouseStatusController', ['$scope','$http','renderSelect', function($scope,$http, renderSelect) {
            console.log('load tình trạng kho');
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/warehouses/getAllWarehouses', reponseType: 'json'}).
                success(function(data, status) {
                    renderSelect.initDataSelect(data.products,'#filter_product_type','Sản phẩm');
                    renderSelect.initSelect();
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
                alert("Lỗi");
                return false;
            }
            if(isNaN(value)){
                alert("Lỗi");
                return false;
            }
            $scope.transferList.push({remaining: (quantity - value),product_id: product_id, quantity: value, product_name: product_name, unit: unit});
            $('#quanity_product_' + product_id).text(quantity - value);
        };
        $scope.saveTransfer = function(){
            if(!$scope.warehouse_to){
                alert('Chọn sản phẩm');
                return false;
            }
            if($scope.transferList.length === 0){
                alert('Chọn sản phẩm');
                return false;
            }
            if($scope.warehouse_from == $scope.warehouse_to){
                alert('Lỗi');
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
            if($stateParams.type === 'partner'){
                $scope.customer_name = 'Đối tác';
                $scope.type_customer = 'Ngành hàng';
            }
            else{
                $scope.customer_name = 'Khách hàng';
                $scope.type_customer = 'Cửa hàng';
            }
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
            if(!confirm('Chắc không'))
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
                $scope.customer_name = 'khách hàng';
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
    .controller('createOrderController', ['$scope','$http','$location','showAlert','renderSelect','$filter', function($scope, $http, $location, showAlert, renderSelect, $filter) {
        $scope.order = {};
        $scope.order.note = '';
        $scope.searchCustomer = '';
        $scope.customer_print;
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/order/createOrder?type=customer', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.customers = data.customers;
                    $scope.products = data.products;
                    $scope.units = data.units;
                    renderSelect.initDataSelect(data.products,'#tr_order_1 select.load_product','Sản phẩm',true);
                    renderSelect.initSelect();
                }).
                error(function(data, status) {
                  console.log(data);
                });
        };
        $scope.init(); 
        $scope.printMe = function(order_id){
            //prepare data for print
            console.log($scope.customer_print)
            var phone = '',
                name = '',
                debt = ''
            if($scope.customer_print.phone_home.length > 0)
                phone += $scope.customer_print.phone_home[0] + ' '
            if($scope.customer_print.phone_mobile.lengh > 0)
                phone += $scope.customer_print.phone_mobile[0]
            if($scope.customer_print.name)
                name = $scope.customer_print.name;
            if($scope.customer_print.total_debt.debt)
                debt = numeral($scope.customer_print.total_debt.debt).format('0,0');
            var html = '';
            var i = 1;
            var table = $filter('filter')($scope.order.orders,function(item){
                var product = $filter('filter')($scope.products,function(actual,expected){
                    return angular.equals(actual.id,item.product_id)
                });
                html += '<tr><td>' + i + '</td>';
                html += '<td>' + product[0].name + '</td>';
                html += '<td>' + item.quantity + '</td>';
                html += '<td>' + numeral(item.price).format('0,0') + '</td>';
                html +='</tr>'
                i++
            })
            
            console.log($scope.order)
//            return false;
            var popupWin = window.open('', '_blank', 'width=80');
            popupWin.document.open()
            popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" />' +
                                    '<style>table tfoot{text-align: right;} table, th, td {border: 1px solid black;} table{width: 100%;border-collapse: collapse;}</style>' + 
                                    '</head>' +
                                    '<body onload="window.print(); window.close()">' +
                                    '<div style="text-align: center"><h1>TUẤN MAI</h1></div>' +
                                    '<div>Địa chỉ: ' + $scope.customer_print.address + '</div>' +
                                    '<div>Điện thoại: ' + phone + '</div>' +
                                    '<div>Mã HĐ: ' + order_id.replace(/"/ig,'') + '</div>' +
                                    '<div>Tên KH: ' + name + '</div><br>' +
                                    '<div><table><thead><tr style="text-align: center"><td>stt</td><td>Tên SP</td><td>sl</td><td>Tien</td></tr></thead>' +
                                    '<tbody>' + html + '</tbody>' +
                                    '<tfoot><tr><td colspan="4">Tổng cộng: ' + numeral($scope.order.total_price).format('0,0') + 
                                    '<br>Tổng nợ:' + debt + ' </td></tr></tfoot></table></div>' +
                                    '</body></html>');
            popupWin.document.close();
        }
        $scope.selectCustomer = function (){
            $scope.searchCustomer = '';
            $scope.customer_name = this.item.name;
            $scope.address_store = this.item.address;
            $scope.phone_mobile = this.item.phone_mobile;
            $scope.phone_home = this.item.phone_home;
            $scope.total_debt = this.item.total_debt.debt;
            $scope.order.customer_id = this.item.id;
            $scope.customer_print = this.item
        };
        
        $scope.selectProduct = function(){
            var target_id = $(event.currentTarget).closest('tr').data('id');
            $scope.products.forEach(function(product){
                    if(product.code === $('#tr_order_' + target_id).children('td:nth-child(3)').children('select.load_product').val()){
                        $('#tr_order_' + target_id + ' td:nth-child(5)').html('<select data-placeholder="Quy cách" ng-model="select_unit" onchange="angular.element(this).scope().selectUnit()" class="chzn-select load_unit"></select>');
                        renderSelect.initDataSelect(product.sale_price, '#tr_order_' + target_id + ' select.load_unit','Quy cách');
                        if(product.buy_price){
                            $('#tr_order_' + target_id).children('td:nth-child(4)').children('input.show_buy').val(numeral(parseInt(product.buy_price[0].price) / parseInt(product.buy_price[0].quantity)).format('0,0'));
                            $('#tr_order_' + target_id).children('td:nth-child(4)').children('input.show_buy_origin').val(product.buy_price[0].id);
                        }
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
            $('#tr_order_' + new_id + ' td:nth-child(3)').html('<select data-placeholder="Sản phẩm" ng-model="select_product" onchange="angular.element(this).scope().selectProduct()" class="chzn-select load_product"></select>');
            renderSelect.initDataSelect($scope.products,'#tr_order_' + new_id + ' select.load_product','Sản phẩm',true);
            $('#tr_order_' + new_id + ' td:nth-child(1)').html('');
            $('#tr_order_' + new_id + ' td:nth-child(7)').html('<input style="width: 50px" ng-model="quantity" onkeyup="angular.element(this).scope().calculatorPrice()" type="text"/>');
            $('#tr_order_' + new_id + ' td:nth-child(2)').html(new_id);
            renderSelect.initSelect();
        };
        $scope.saveOrder = function(){
            var orders = new Array();
            var product_id
            $('.product_order').each(function(){
                var that = this;
                $scope.products.forEach(function(product){
                    if(product.code == $(that).children('td:nth-child(3)').children('select').val())
                        product_id = product.id;
                })
                var order = {product_id: product_id,
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
                $scope.printMe(data);
                showAlert.showSuccess(3000,'Lưu thành công');
				$location.path('order-management');
            }).
            error(function(data, status) {
              console.log(data);
            });
        };
    }])
    .controller('managementOrderController', ['$scope','$http','showAlert','$location','renderSelect', function($scope, $http, showAlert, $location, renderSelect) {
        $scope.orders = new Array();
        $scope.order_tmp = new Array();
        $scope.shipments = new Array();
        $scope.date = new Date();
        var order_tmp = new Array();
        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/order/managementOrder', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.orders = data.orders;
                    renderSelect.initDataSelect(data.trucks, '#order-truck-manager','Xe');
                    renderSelect.initDataSelect(data.staffs, '#order-staff-driver','Tài xế',null,null,null,2);
                    renderSelect.initDataSelect(data.staffs, '#order-staff-subdriver','Lơ xe',null,null,null,3);
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
                        $scope.order_tmp.push($scope.orders[x]);
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
                $scope.order_tmp.forEach(function(order){
                    $scope.orders.push(order);
                })
                $scope.order_tmp = new Array();
                $scope.shipments = data.orders;
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
                showAlert.showSuccess(3000,'Lưu thành công');
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
                    alert('Quá số lượng trong kho');
                    return false;
                }
                //get quantity all warehouse
                $('.warehouse_quantity_' + product_id).each(function(){
                    if(this.value !== '')
                        total += parseInt(this.value);
                });
                if(total > product_quantity){
                    alert('Quá số lượng cần giao');
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
                      showAlert.showSuccess(3000,'Lưu thành công');
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
        $scope.formatNumber = function(){
            var value = $(event.currentTarget).val().replace(/,/ig,'');
            $(event.currentTarget).val(numeral(value).format('0,0'));
        }
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
                price = $('#price_shipment_' + shipment_id + '_order_' + order_id).val().replace(/,/ig,''),
                debit = $('#debit_shipment_' + shipment_id + '_order_' + order_id).val().replace(/,/ig,'');

            switch (status_id){
                case "3":
                    $scope.createBill(order_id,price, shipment_id);
                    break;
                case "4":
                    $location.path('order-return/' + order_id);
                    break;
                case "6":
                    $scope.createBillAndReturnStore(order_id,price, shipment_id,debit);
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
        $scope.createBillAndReturnStore = function(order_id, price, shipment_id,debit){
            $http({method: 'POST', url: config.base + '/warehouse_wholesale_sale/createBillAndReturnStore',data: {order_id: order_id,price: price, shipment_id: shipment_id,debit: debit}, reponseType: 'json'}).
                success(function(data, status) {
                    $location.path('order-return-half/' + order_id + '/' + data);
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
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
            $scope.total_price = 0;
            $scope.init = function (){
                $http({method: 'GET', url: config.base + '/order/returnWarehouse?order_id=' + $stateParams.order_id, reponseType: 'json'}).
                    success(function(data, status) {
                        $scope.products = data.order;
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init(); 
            
            $scope.quantityWarehouse = function($event,retail){
                if(!retail){
                    var value = parseInt($($event.currentTarget).val()),
                        product_id = parseInt($($event.currentTarget).data('product-id')),
                        product_quantity = parseInt($('#origin_quantity_' + product_id).val()),
                        total = 0;
                }else{
                    var value = parseInt($($event.currentTarget).val()),
                        product_id = parseInt($($event.currentTarget).data('product-id')),
                        product_quantity = parseInt($('#origin_quantity_retail_' + product_id).val()),
                        total = 0;
                }
                //get quantity all warehouse
                if(!retail){
                    $('.warehouse_quantity_' + product_id).each(function(){
                        if(this.value !== '')
                            total += parseInt(this.value);
                    });
                }else{
                    $('.retail_quantity_' + product_id).each(function(){
                        if(this.value !== '')
                            total += parseInt(this.value);
                    });
                }
                if(total > product_quantity){
                    alert('Quá số lượng cần giao');
                    $($event.currentTarget).val('');
                    return false;
                }
                
                if(!retail)
                    $('#show_quantity_' + product_id).text(product_quantity - total);
                else
                    $('#show_quantity_retail_' + product_id).text(product_quantity - total);
                
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
                        showAlert.showSuccess(3000,'Lưu thành công');
                        $location.path('order-status');
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
    }])
    .controller('returnOrderHalfController', ['$scope','$http', '$stateParams','showAlert','$location', function($scope, $http, $stateParams, showAlert, $location) {
            $scope.total_price = 0;
            $scope.init = function (){
                $http({method: 'GET', url: config.base + '/order/returnHalfWarehouse?order_id=' + $stateParams.order_id, reponseType: 'json'}).
                    success(function(data, status) {
                        $scope.products = data.order;
                        $scope.retails = data.retail;
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
            $scope.init(); 
            $scope.getTotal = function(){
                var price = 0;
                $('.new_price').each(function(){
                    var value = parseInt($(this).text().replace(/,/ig,''))
                    price += value;
                })
                $scope.total_price = numeral(price).format('0,0');
            }
            $scope.quantityWarehouse = function($event,retail){
                if(!retail){
                    var value = parseInt($($event.currentTarget).val()),
                        product_id = parseInt($($event.currentTarget).data('product-id')),
                        product_quantity = parseInt($('#origin_quantity_' + product_id).val()),
                        total = 0;
                }else{
                    var value = parseInt($($event.currentTarget).val()),
                        product_id = parseInt($($event.currentTarget).data('product-id')),
                        product_quantity = parseInt($('#origin_quantity_retail_' + product_id).val()),
                        total = 0;
                }
                //get quantity all warehouse
                if(!retail){
                    $('.warehouse_quantity_' + product_id).each(function(){
                        if(this.value !== '')
                            total += parseInt(this.value);
                    });
                }else{
                    $('.retail_quantity_' + product_id).each(function(){
                        if(this.value !== '')
                            total += parseInt(this.value);
                    });
                }
                if(total > product_quantity){
                    alert('Quá số lượng cần giao');
                    $($event.currentTarget).val('');
                    return false;
                }
                
                if(!retail)
                    $('#show_quantity_' + product_id).text(product_quantity - total);
                else
                    $('#show_quantity_retail_' + product_id).text(product_quantity - total);
                
                var price = $($event.currentTarget).closest('td').next().children('input').val()
                var new_price = parseInt(price) / parseInt(product_quantity) * total;
                $($event.currentTarget).closest('td').next().children().text(numeral(new_price).format('0,0'))
                $scope.getTotal();
            };
            $scope.calPrice = function(){
                
                var value = parseInt($scope.actual_price.replace(/,/ig,''));
                if(isNaN(value) || value == '')
                    value = 0
                var total = parseInt($scope.total_price.replace(/,/ig,''));
                $scope.debit = numeral(total - value).format('0,0');
                $scope.actual_price = numeral(value).format('0,0')
            }
            $scope.divideWarehouse = function(){
                var product = new Array;
                $('.warehouse_quantity').each(function(){
                    var quantity = $(this).val(),
                        price = parseInt($(this).closest('td').next().children('span').text().replace(/,/ig,'')),
                        product_id  = $(this).data('product-id'),
                        warehouse_id = $(this).data('warehouse-id');
                    if(quantity !== '')
                        product.push({product_id: product_id,price: price,warehouses_id: warehouse_id,quantity: quantity});
                });
                var retail = new Array();
                $('.retail_quantity').each(function(){
                    var quantity = $(this).val(),
                        price = parseInt($(this).closest('td').next().children('span').text().replace(/,/ig,'')),
                        product_id  = $(this).data('product-id');
                    if(quantity !== '')
                        retail.push({product_id: product_id,price: price,quantity: quantity});
                })
                var data = {product: product,
                            retail: retail,
                            debit: $scope.debit.replace(/,/ig,''),
                            price: $scope.actual_price.replace(/,/ig,'')};
                
                $http({method: 'POST', url: config.base + '/order/getReturnHalfWarehouse?order_id=' + $stateParams.order_id + '&bill_id=' + $stateParams.bill_id,data: data, reponseType: 'json'}).
                    success(function(data, status) {
                        showAlert.showSuccess(3000,'Lưu thành công');
//                        $location.path('order-status');
                    }).
                    error(function(data, status) {
                      console.log(data);
                    });
            };
    }])
    .controller('trucksController', ['$scope','$http','$modal', function($scope, $http,  $modal) {

        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/trucks', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.trucks = data.trucks;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        };
        $scope.init();
        $scope.deleteTruck = function($event){
            if(!confirm('B?n ch?c ch??'))
                return false;
            $http({method: 'GET', url: config.base + '/trucks/deleteTruck?id=' + $($event.currentTarget).attr('id'), reponseType: 'json'}).
                success(function(data, status) {
                    $scope.init();
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.openPopup = function(size,$event){
            if($event)
                var truck_id = $($event.currentTarget).data('id');
            var modalInstance = $modal.open({
                templateUrl: 'create_truck',
                controller: 'createTruckCustomerController',
                size: size,
                resolve: {
                    items: function () {
                        return {truck_id: truck_id};
                    }
                }
            });
            modalInstance.result.then(function () {
                $scope.init();
            });
        };
    }])
    .controller('createTruckCustomerController', function ($scope,$http, $modalInstance, items) {
        $scope.truck = {};
        if(items.truck_id){
            $http({method: 'GET', url: config.base + '/trucks/getTruck?id=' + items.truck_id, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.truck = data.truck;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }

        $scope.ok = function () {
            if(items.truck_id)
                var url = config.base + '/trucks/editTruck?id=' + items.truck_id;
            else
                var url = config.base + '/trucks/createTruck';

            if(!$scope.truck.name){
                alert('vui lòng chọn xe');
                return false;
            }

            $http({method: 'POST', url: url,data: $scope.truck, reponseType: 'json'}).
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
    .controller('createStaffController', ['$scope','$http','$location','$stateParams','renderSelect', function($scope, $http, $location, $stateParams, renderSelect) {
        $scope.staff = {};
        $scope.init = function(staff_id){
            $http({method: 'GET', url: config.base + '/staff/detailStaff?id=' + staff_id, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.staff = data.staff;

                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.getPosition = function(){
            $http({method: 'GET', url: config.base + '/staff/getPosition', reponseType: 'json'}).
                success(function(data, status) {
                    renderSelect.initDataSelect(data.position,'#staff_position','Vị trí',null,null,$scope.staff.position)
                    renderSelect.initSelect();
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        
        if($stateParams.id)
            $scope.init($stateParams.id);
        
        $scope.getPosition();
        $scope.uploadFile = function(files) {
            var fd = new FormData();
            //Take the first selected file
            fd.append("file", files[0]);

            $http.post(config.base + '/staff/uploadAvatar', fd, {
                withCredentials: true,
                headers: {'Content-Type': undefined },
                transformRequest: angular.identity
            }).success(function(data){
                $('.avartar img').prop('src','www/img/avatar_staff/' + data);
                $scope.staff.avatar = data;
            }).error();

        };
        $scope.formatNumber = function($event){
            var value = $($event.currentTarget).val();
            $scope.staff.salary = value.replace(/,/ig,'');
            $($event.currentTarget).val(numeral($scope.staff.salary).format('0,0'))
        }

        $scope.saveStaff = function() {
            if($stateParams.id)
                var url = config.base + '/staff/editStaff?id=' + $stateParams.id;
            else
                var url = config.base + '/staff/createStaff';

            $http({method: 'POST', url: url,data: $scope.staff, reponseType: 'json'}).
                success(function(data, status) {
                    $location.path('staff');
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
    }])
    .controller('staffController', ['$scope','$http','$location', function($scope, $http, $location) {
        $scope.init = function(){
            $http({method: 'POST', url: config.base + '/staff', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.staffs = data.staffs;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.init();
        $scope.editStaff = function(){
            $location.path('staff-edit/' + this.item.id);
        }
    }])
    .controller('listOrderController', ['$scope','$http','$location', function($scope, $http, $location) {
        $scope.init = function(){
            $http({method: 'POST', url: config.base + '/order', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.orders = data.orders;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.init();
        $scope.editStaff = function(){
            $location.path('staff-edit/' + this.item.id);
        }
    }])
    .controller('detailOrderController', ['$scope','$http','$location','$stateParams','$modal', function($scope, $http, $location,$stateParams,$modal) {
        
        $scope.init = function(){
            $http({method: 'POST', url: config.base + '/order/getOrder?id=' + $stateParams.order_id, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.order = data.order;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.init();
        $scope.deleteProduct = function(){
            if(confirm('Chắc chứ?'))
                $scope.order.order_detail.splice(this.$index, 1);
        }
        $scope.calulationPrice = function($event){
            var quantity = $($event.currentTarget).val(),
                price = parseInt($('#price_product_' + this.$index).text().replace(/,/ig,''));
            if(quantity == '')
                quantity = 0;
            
            var total = price * parseInt(quantity);
            $('#total_product_' + this.$index).text(numeral(total).format('0,0'))
        }
        $scope.updateOrder = function(){
            $('.new_quantity').each(function(){
                var key = $(this).data('key')
                $scope.order.order_detail[key].quantity = this.value;
                $scope.order.order_detail[key].total = $('#total_product_' + key).text().replace(/,/ig,'')
            })
            $http({method: 'POST', url: config.base + '/order/updateOrderDetail?order_id=' + $stateParams.order_id,data: {order_detail: $scope.order.order_detail,note: $scope.order.note}, reponseType: 'json'}).
            success(function(data, status) {
                $location.path('order-list');
            }).
            error(function(data, status) {
                console.log(data);
            });
        }
        $scope.openPopup = function(size,$event){
            var modalInstance = $modal.open({
                templateUrl: 'add_product',
                controller: 'addProductController',
                size: 'lg'
            });
            modalInstance.result.then(function (data) {
                $scope.order.order_detail.push(data)
            });
        };
    }])
    .controller('addProductController', function ($scope,$http, $modalInstance, renderSelect) {
        $scope.order = {};
        $scope.product_id = 0;
        $scope.init = function(){
        $http({method: 'GET', url: config.base + '/order/addProductPopup', reponseType: 'json'}).
            success(function(data, status) {
                $scope.products = data.products;
                $scope.units = data.units;
                renderSelect.initDataSelect(data.products,'#tr_order_1 select.load_product','Sản phẩm',true);
                renderSelect.initSelect();
            }).
            error(function(data, status) {
                console.log(data);
            });
        }
        $scope.init();
        $scope.selectProduct = function(){
            var target_id = $(event.currentTarget).closest('tr').data('id');
            $scope.products.forEach(function(product){
                    if(product.code === $('#tr_order_' + target_id).children('td:nth-child(3)').children('select.load_product').val()){
                        $('#tr_order_' + target_id + ' td:nth-child(5)').html('<select data-placeholder="Quy cách" ng-model="select_unit" onchange="angular.element(this).scope().selectUnit()" class="chzn-select load_unit"></select>');
                        renderSelect.initDataSelect(product.sale_price, '#tr_order_' + target_id + ' select.load_unit','Quy cách');
                        if(product.buy_price){
                            $('#tr_order_' + target_id).children('td:nth-child(4)').children('input.show_buy').val(numeral(parseInt(product.buy_price[0].price) / parseInt(product.buy_price[0].quantity)).format('0,0'));
                            $('#tr_order_' + target_id).children('td:nth-child(4)').children('input.show_buy_origin').val(product.buy_price[0].id);
                        }
                        renderSelect.initSelect();
                        return false;
                }
            });
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
        $scope.ok = function () {
            var product_id = $('.load_product').val();
            $scope.order.cost = $('.show_buy_origin').val();
            $scope.order.unit = $('.load_unit').val();
            $scope.order.price = $('.show_sale_origin').val();
            $scope.order.total = $('.price_order').val();
            
            //get product id
            for(var x in $scope.products){
                if($scope.products[x].code == product_id){
                    $scope.order.product_id = $scope.products[x].id;
                    break;
                }
            }
            
            $http({method: 'GET', url: config.base + '/order/getInventory?unit=' + $scope.order.unit, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.order.product_detail = data.product_detail
                    $scope.order.unit_detail = data.unit_detail
                    $modalInstance.close($scope.order);
                }).
                error(function(data, status) {
                    console.log(data);
                });
        };

        $scope.cancel = function () {
            $modalInstance.dismiss('cancel');
        };
    })
    .controller('listUserController', ['$scope','$http','$modal','renderSelect', function($scope, $http, $modal, renderSelect) {

        $scope.init = function (){
            $http({method: 'GET', url: config.base + '/user', reponseType: 'json'}).
                success(function(data, status) {
                    $scope.users = data.users;
                    $scope.roles = data.roles;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        };
        $scope.init();
        $scope.deleteUser = function($event){
            if(!confirm('Chắc không?'))
                return false;
            $http({method: 'GET', url: config.base + '/user/deleteUser?id=' + $($event.currentTarget).attr('id'), reponseType: 'json'}).
                success(function(data, status) {
                    $scope.init();
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.openPopup = function(size,$event){
            if($event)
                var user_id = $($event.currentTarget).data('id');
            var modalInstance = $modal.open({
                templateUrl: 'create_user',
                controller: 'createUserController',
                size: size,
                resolve: {
                    items: function () {
                        return {user_id: user_id,roles: $scope.roles};
                    }
                }
            });
            modalInstance.result.then(function () {
                $scope.init();
            });
        };
    }])
    .controller('createUserController', function ($scope,$http, $modalInstance, items, renderSelect) {
        $scope.user = {};
        if(items.user_id){
            $http({method: 'GET', url: config.base + '/user/getUser?id=' + items.user_id, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.user = data.user;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        setTimeout(function(){
            renderSelect.initDataSelect(items.roles,'#user_role','Quyền',null,null,$scope.user.role);
            renderSelect.initSelect();
          }, 1000);
        
        $scope.ok = function () {
            if(items.user_id)
                var url = config.base + '/user/editUser?id=' + items.user_id;
            else
                var url = config.base + '/user/createUser';

            if(!$scope.user.user_name){
                alert('vui lòng điền tên');
                return false;
            }
            
            $http({method: 'POST', url: url,data: $scope.user, reponseType: 'json'}).
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
    .controller('shipmentController', ['$scope','$http', function($scope, $http) {

        $scope.shipments = new Array();
        $scope.open = function($event) {
          $event.preventDefault();
          $event.stopPropagation();
          $scope.opened = true;
        };
        $scope.findShipment = function(){
            if(!$scope.from_date || !$scope.to_date)
                return false;
            
            //get shipment
            $http({method: 'GET', url: config.base + '/shipment?from=' + $('#from_date').val() + '&to=' + $('#to_date').val(), reponseType: 'json'}).
                success(function(data, status) {
                    $scope.shipments = data.shipments;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
    }])
    .controller('shipmentDetailController', ['$scope','$http','$stateParams', function($scope, $http, $stateParams) {

        $scope.init = function(){
            $http({method: 'GET', url: config.base + '/shipment/shipmentDetail?id=' + $stateParams.shipment_id, reponseType: 'json'}).
                success(function(data, status) {
                    $scope.shipment = data.shipment;
                }).
                error(function(data, status) {
                    console.log(data);
                });
        }
        $scope.init();
    }])
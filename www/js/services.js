'use strict';

angular.module('dashboard.services', [])
    .factory('showAlert', function() {
        var httpApi = {};

        httpApi.showSuccess = function(delay,str){
        if(delay){
                $('#alertMessage').removeClass('error info warning').addClass('success').html(str).stop(true,true).show().animate({ opacity: 1,right: '10'}, 500,function(){
                                $(this).delay(delay).animate({ opacity: 0,right: '-20'}, 500,function(){ $(this).hide(); });																														   																											
                      });
                return false;
            }
            $('#alertMessage').addClass('success').html(str).stop(true,true).show().animate({ opacity: 1,right: '10'}, 500);	
        };
        return httpApi;
    })
    .factory('renderSelect', function() {
        var httpApi = {};

        httpApi.initDataSelect = function(data,target,placeholder,code,store,default_select,limit,product_type){
            var html ='';
            $(target).next('div').remove();
            $(target).removeClass('chzn-done');
            $(target).html(html);
            html += '<option value="0">' + placeholder + '</option>';
            
            //init select with filter
            if(product_type){
                for (var x in data) {
                        html += '<option value="' + data[x].name + '">' + data[x].name + '</option>';
                }
                $(target).html(html);
                return false;
            }
            if(limit){
                for (var x in data) {
                    if(data[x].position == limit)
                        html += '<option value="' + data[x].id + '">' + data[x].name + '</option>';
                }
                $(target).html(html);
                return false;
            }
            
            //render select with default select
            if(default_select){
                for (var x in data) {
                    var select = '';
                    if(default_select == data[x].id)
                        select = 'selected';
                    html += '<option value="' + data[x].id + '" ' + select + '>' + data[x].name + '</option>';
                }
                $(target).html(html);
                return false;
            }
            
            //render select store
            if(store){
                for (var x in data) {
                    html += '<option value="' + data[x].id + '">' + data[x].store_name + '</option>';
                }
                $(target).html(html);
                return false;
            }
            //render select with code product
            if(!code) {
                for (var x in data) {
                    html += '<option value="' + data[x].id + '">' + data[x].name + '</option>';
                }
            }else{
                for (var x in data) {
                    html += '<option value="' + data[x].code + '">' + data[x].name + '</option>';
                }
            }
            $(target).html(html);
        };
        httpApi.initSelect = function(){
            $(' select').not("select.chzn-select,select[multiple],select#box1Storage,select#box2Storage").selectmenu({
                style: 'dropdown',
                transferClasses: true,
                width: null
            });

            $(".chzn-select").chosen();
        };
        return httpApi;
    })
    .service('customers',['$http',function($http){
        return {
            getCustomer: function(customer_id,callback){
                $http.get(config.base + '/customers/getCustomer?id=' + customer_id)
                    .success(function(result){
                        callback(result)
                    })
            }
        }
    }]);
'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
//angular.module('onBoard.services', []).
//    factory('httpAPIservice', function($http) {
//
//        var httpAPI = {};
//
//        httpAPI.get = function(url) {
//            return $http({
//                method: 'JSONP',
//                url: url
//            });
//        }
//
//        return httpAPI;
//    });

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

        httpApi.initDataSelect = function(data,target,code){
            var html ='';
            $(target).next('div').remove();
            $(target).removeClass('chzn-done');
            $(target).html(html);
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
    });;
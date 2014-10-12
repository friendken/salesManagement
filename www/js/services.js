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
        }
        return httpApi;
    });
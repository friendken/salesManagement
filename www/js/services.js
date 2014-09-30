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

angular.module('dashboard.services', []).
    factory('updateLogin', function($http) {

        var httpAPI = {};

        httpAPI.update = function() {
            return $http({
                method: 'POST',
                url: config.base + 'api/onboard/exitOnboard',
                reponseType: 'json'
            });
        }

        return httpAPI;
    });
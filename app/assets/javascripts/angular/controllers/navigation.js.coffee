dependencies = ['kassa.session']

navController =  ($scope, $location, Session)->
    $scope.session = Session
    $scope.currentLocation = (path)->
      $location.path() == path

angular.module('kassa.controllers.navigation',dependencies) 
.controller('NavigationController', ['$scope', '$location', 'Session', navController])

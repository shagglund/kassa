angular.module('kassa.controllers.navigation', ['kassa.session'])
  .controller('NavigationController', ($scope, $location, Session)->
    $scope.session = Session
    $scope.currentLocation = (path)->
      $location.path() == path
  )

angular.module('kassa.navigation', [])
  .controller('NavigationController', ($scope, $location)->
    $scope.currentLocation = (path)->
      $location.path() == path
  )

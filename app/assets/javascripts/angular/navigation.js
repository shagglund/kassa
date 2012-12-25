angular.module('Kassa.Navigation', [])
  .controller('NavigationController', function($scope, $location){
    $scope.currentLocation = function(path){
      return $location.path() === path
    }
  });
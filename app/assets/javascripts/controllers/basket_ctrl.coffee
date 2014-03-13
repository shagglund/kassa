angular.module('kassa').controller 'BasketCtrl', [
  '$scope'
  '$location'
  'BasketService'
  'SessionService'
  ($scope, $location, Basket, Session)->
    $scope.basket = Basket
]
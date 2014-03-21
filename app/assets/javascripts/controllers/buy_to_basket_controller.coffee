angular.module('kassa').controller 'BuyToBasketCtrl', [
  '$scope'
  'BasketService'
  ($scope, Basket)->
    undo = (buy)->

    canBeDeleted = (buy)->

    $scope.setToBasket = Basket.setFromBuy
    $scope.delete = undo
    $scope.canBeDeleted = canBeDeleted
]
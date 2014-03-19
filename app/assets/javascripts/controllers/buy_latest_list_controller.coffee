angular.module('kassa').controller 'BuyLatestListController', [
  '$scope'
  '$location'
  'BuyService'
  'BasketService'
  ($scope, $location, Buy, Basket)->
    Buy.all(limit: 20).then (buys)-> $scope.buys = buys

    undo = (buy)->

    canBeDeleted = (buy)->

    $scope.setToBasket = Basket.setFromBuy
    $scope.delete = undo
    $scope.canBeDeleted = canBeDeleted
]
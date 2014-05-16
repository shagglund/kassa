angular.module('kassa').controller 'BuyToBasketCtrl', [
  '$scope'
  'BasketService'
  ($scope, Basket)->
    undo = (buy)->

    canBeDeleted = (buy)-> false

    _productsFromBuyEntries = (entry)-> entry.product

    _allProductsAvailable = (available, product)->
      available && product.available

    allProductsAvailable = (buy)->
      _.chain(buy.consistsOfProducts)
      .map _productsFromBuyEntries
      .reduce _allProductsAvailable, true
      .value()

    $scope.setToBasket = Basket.setFromBuy
    $scope.delete = undo
    $scope.canBeDeleted = canBeDeleted
    $scope.allProductsAvailable = allProductsAvailable
]
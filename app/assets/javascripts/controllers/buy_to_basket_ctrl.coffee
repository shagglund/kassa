angular.module('kassa').controller 'BuyToBasketCtrl', [
  '$scope'
  'BasketService'
  ($scope, Basket)->
    productsFromBuyEntries = (entry)-> entry.product

    availableProductsMapper = (available, product)->
      available && product.available

    allProductsAvailable = (buy)->
      _.chain(buy.consistsOfProducts)
      .map productsFromBuyEntries
      .reduce availableProductsMapper, true
      .value()

    $scope.setToBasket = Basket.setFromBuy
    $scope.allProductsAvailable = allProductsAvailable
]
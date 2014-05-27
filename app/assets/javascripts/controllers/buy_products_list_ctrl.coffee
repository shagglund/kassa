angular.module('kassa').controller 'BuyProductsListCtrl', [
  '$scope'
  '$q'
  'ProductService'
  'BasketService'
  'StateService'
  ($scope, $q, Product, Basket, State)->
    stateHandler = State.getHandler('BuyProductsListCtrl:state')
    handleStateChanges = stateHandler.handleStateChanges

    Product.all().then (products)-> $scope.products = products

    buy = ->
      return unless Basket.isBuyable()
      handleStateChanges Basket.buy()

    $scope.basket = Basket
    $scope.buy = buy
    $scope.state = stateHandler
]
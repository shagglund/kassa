angular.module('kassa').controller 'BuyProductsListCtrl', [
  '$scope'
  '$q'
  'ProductService'
  'BasketService'
  ($scope, $q, Product, Basket)->
    Product.all().then (products)-> $scope.products = products

    STATE_ERROR = 1
    STATE_SUCCESS = 2
    STATE_DEFAULT = 3

    handleSuccess = (buy)->
      console.log 'handling success'
      $scope.state = STATE_SUCCESS
      buy

    handleError = (resp)->
      console.log 'handling error'
      $scope.state = STATE_ERROR
      $q.reject(resp)

    buy = ->
      return unless Basket.isBuyable()
      Basket.buy().then(handleSuccess, handleError)

    $scope.basket = Basket
    $scope.buy = buy
    $scope.state = STATE_DEFAULT
    $scope.DEFAULT = STATE_DEFAULT
    $scope.ERROR = STATE_ERROR
]
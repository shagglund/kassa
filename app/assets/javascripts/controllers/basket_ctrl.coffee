angular.module('kassa').controller 'BasketCtrl', [
  '$scope'
  '$location'
  '$q'
  'BasketService'
  'SessionService'
  'BuyService'
  ($scope, $location, $q, Basket, Session, Buy)->
    $scope.basket = Basket

    STATE_ERROR = 0
    STATE_SUCCESS = 1
    STATE_DEFAULT = 2

    handleSuccess = (buy)->
      Basket.empty(false)
      $scope.state = STATE_SUCCESS
      buy

    handleError = (resp)->
      $scope.state = STATE_ERROR
      $q.reject(resp)

    buy = ->
      return unless Basket.isBuyable()
      Buy.create(Basket.buyer(), Basket.products()).then(handleSuccess, handleError)

    $scope.buy = buy
    $scope.state = STATE_DEFAULT
    $scope.DEFAULT = STATE_DEFAULT
    $scope.ERROR = STATE_ERROR
]
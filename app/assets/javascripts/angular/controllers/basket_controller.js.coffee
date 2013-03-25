dependencies = [
  'kassa.services.basket'
  'kassa.ui.dialogs.basket'
]
angular.module('kassa.controllers.basket', dependencies)
.controller('BasketController', ($scope, Basket, BasketDialog)->
  $scope.basket = Basket
  $scope.dialog = BasketDialog

  $scope.buy= ->
    success = ->
      Basket.clear()
      BasketDialog.close()
    failure=  (errorResponse)->
      Basket.errors(errorResponse.data)
    Basket.buy().then success, failure

  $scope.clear=->
    Basket.clear()
    BasketDialog.close()

  $scope.balanceAfterBuy = ->
    return 0 unless angular.isDefined Basket.buyer
    Basket.buyer.attributes.balance - Basket.totalPrice()

)

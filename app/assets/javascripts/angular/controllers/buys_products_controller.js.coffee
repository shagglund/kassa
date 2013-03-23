dependencies =  [
  'kassa.services.basket'
  'kassa.services.data'
  'kassa.ui.dialogs.basket'
]
angular.module('kassa.controllers.buys.products', dependencies)
.controller('BuysProductsController', ($scope, Basket, DataService, BasketDialog)->
  $scope.basket = Basket
  $scope.dialog = BasketDialog
  
  $scope.entries = ->
    DataService.collection('products')

)

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
    if angular.isDefined($scope.filterQueries) and $scope.filterQueries.length > 0
      exps = (new RegExp(query,'i') for query in $scope.filterQueries)
      _.select DataService.collection('products'), (p)->
        return true for e in exps when e.test p.attributes.name
    else
      DataService.collection('products')

)

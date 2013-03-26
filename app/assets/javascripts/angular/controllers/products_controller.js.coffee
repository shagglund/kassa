dependencies=[
  'kassa.services.data'
  'kassa.ui.dialogs.material'
]
angular.module('kassa.controllers.products', dependencies)
.controller('ProductsController', ($scope, $routeParams, DataService, MaterialDialog)->
  $scope.dialog = MaterialDialog

  $scope.entries = ->
    if angular.isDefined($scope.filterQueries) and $scope.filterQueries.length > 0
      exps = (new RegExp(query,'i') for query in $scope.filterQueries)
      _.select DataService.collection('products'), (p)->
        return true for e in exps when e.test p.attributes.name
    else
      DataService.collection 'products'
      

  $scope.materials= ->
    DataService.collection 'materials'

  $scope.newMaterial=->
    DataService.new 'material'

  $scope.inGroup= (group, product)->
    return false if angular.isUndefined(product)
    product.hasGroup(group)

  $scope.newProduct = DataService.new 'product'

  if angular.isDefined $routeParams.id
    $scope.currentProduct = DataService.find 'product', $routeParams.id
  else
    $scope.currentProduct = $scope.newProduct
)

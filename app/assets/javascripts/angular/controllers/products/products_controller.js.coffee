dependencies=[
  'kassa.services.data'
]
pController = ($scope, $routeParams, DataService)->
  allProducts= ->
    _.merge DataService.collection('basic_products'), DataService.collection('combo_products')

  findProduct= (id)->
    p = DataService.find 'basic_product', $routeParams.id
    p = DataService.find 'combo_product', $routeParams.id if angular.isUndefined(p)
    p

  $scope.entries = ->
    if angular.isDefined($scope.filterQueries) and $scope.filterQueries.length > 0
      exps = (new RegExp(query,'i') for query in $scope.filterQueries)
      _.select allProducts(), (p)->
        return true for e in exps when e.test p.attributes.name
    else
      allProducts()

  $scope.inGroup= (group, product)->
    return false if angular.isUndefined(product)
    product.hasGroup(group)

  if angular.isDefined $routeParams.id
    $scope.currentProduct = findProduct($routeParams.id)
    #TODO remove
    #ugly hack to reload selection after the products have loaded
    #without this the initial id mapping will not load the details
    if angular.isUndefined $scope.currentProduct
      unwatch = $scope.$watch 'entries().length', (val)->
        $scope.currentProduct = findProduct($routeParams.id)
        unwatch() if angular.isDefined($scope.currentProduct)
  else if angular.isDefined($routeParams.new) and $routeParams.new == 'combo'
    $scope.currentProduct = DataService.new 'combo_product'
  else
    $scope.currentProduct = DataService.new 'basic_product'

angular.module('kassa.controllers.products.products', dependencies)
.controller('ProductsController', ['$scope','$routeParams', 'DataService', pController])

dependencies=[
  'kassa.services.data'
]

bpfController =  ($scope, $routeParams, DataService)->
  $scope.currentBasicProduct = DataService.new 'basic_product'

  $scope.$watch 'currentProduct', (newVal)->
    return unless angular.isDefined newVal
    $scope.currentBasicProduct = newVal.firstBasicProduct()

  if angular.isDefined $routeParams.id
    $scope.currentBasicProduct = DataService.find 'basic_product', $routeParams.id

angular.module('kassa.controllers.products.basic_form', dependencies)
.controller('BasicProductFormController',['$scope', '$routeParams', 'DataService', bpfController])

angular.module('kassa').controller 'BuyProductsListController', [
  '$scope'
  '$location'
  'ProductService'
  ($scope, $location, Product)->
    Product.all().then (products)-> $scope.products = products
]
angular.module('kassa').controller('ProductListCtrl', [
  '$scope'
  'ProductService'
  ($scope, Product)->
    Product.all().then (products)-> $scope.products = products
])
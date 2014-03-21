angular.module('kassa').controller('ProductLatestBuysCtrl', [
  '$scope'
  'ProductService'
  'BuyService'
  ($scope, Product, Buy)->
    Product.currentByRoute().then (product)->
      $scope.product = product
      Buy.latestForProduct(product, 10).then (buys)->
        $scope.buys = buys
])
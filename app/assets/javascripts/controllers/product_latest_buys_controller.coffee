angular.module('kassa').controller('ProductLatestBuysCtrl', [
  '$scope'
  'ProductService'
  'BuyService'
  ($scope, Product, Buy)->
    LIMIT = 10
    moreAvailable = null

    Product.currentByRoute().then (product)->
      $scope.product = product
      Buy.latestForProduct(product, limit: LIMIT).then (buys)->
        $scope.buys = buys

    loadMore = (buys)->
      Buy.latestForProduct($scope.product, offset: buys.length, limit: LIMIT).then (loadedBuys)->
        moreAvailable = loadedBuys.length == LIMIT
        buys.push loadedBuys...

    moreAvailable = -> moreAvailable

    $scope.loadMore = loadMore
    $scope.moreAvailable = moreAvailable
])
angular.module('kassa').controller('ProductLatestBuysCtrl', [
  '$scope'
  'ProductService'
  'BuyService'
  ($scope, Product, Buy)->
    LIMIT = 10
    _moreAvailable = true
    buys = []

    load = (buys)->
      return unless moreAvailable()
      Buy.latestForProduct($scope.product, offset: buys.length, limit: LIMIT).then (loadedBuys)->
        _moreAvailable = loadedBuys.length == LIMIT
        buys.push loadedBuys...

    moreAvailable = -> _moreAvailable

    Product.currentByRoute().then (product)->
      $scope.product = product
      load(buys)

    $scope.buys = buys
    $scope.loadMore = load
    $scope.moreAvailable = moreAvailable
])
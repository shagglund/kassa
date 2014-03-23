angular.module('kassa').controller 'BuyLatestListController', [
  '$scope'
  '$location'
  'BuyService'
  'BasketService'
  ($scope, $location, Buy, Basket)->
    LIMIT = 20
    moreAvailable = null

    Buy.latest(limit: LIMIT).then (buys)-> $scope.buys = buys

    loadMore = (buys)->
      Buy.latest(offset: buys.length, limit: LIMIT).then (loadedBuys)->
        moreAvailable = loadedBuys.length == LIMIT
        buys.push buy for buy in loadedBuys

    moreAvailable = -> moreAvailable

    $scope.loadMore = loadMore
    $scope.moreAvailable = moreAvailable
]
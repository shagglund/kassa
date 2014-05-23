angular.module('kassa').controller 'BuyLatestListCtrl', [
  '$scope'
  '$location'
  '$q'
  'BuyService'
  'BasketService'
  ($scope, $location, $q, Buy, Basket)->
    LIMIT = 20
    moreAvailable = null

    buys = Buy.latest(limit: LIMIT).then (loadedBuys)-> $scope.buys = buys = loadedBuys

    loadMore = (buys)->
      Buy.latest(offset: buys.length, limit: LIMIT).then (loadedBuys)->
        moreAvailable = loadedBuys.length == LIMIT
        buys.push loadedBuys...

    moreAvailable = -> moreAvailable

    addNewBuy = (buy)->
      $q.when(buys).then (resolvedBuys)-> resolvedBuys.unshift(buy)

    $scope.loadMore = loadMore
    $scope.moreAvailable = moreAvailable

    $scope.$on 'buys:new', (event, buy)-> addNewBuy(buy)
]
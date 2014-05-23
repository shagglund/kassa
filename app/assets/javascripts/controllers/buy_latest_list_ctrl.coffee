angular.module('kassa').controller 'BuyLatestListCtrl', [
  '$scope'
  'BuyService'
  ($scope, Buy)->
    LIMIT = 20
    _moreAvailable = true

    moreAvailable = -> _moreAvailable

    load = (buys)->
      return unless moreAvailable()
      Buy.latest(offset: buys.length, limit: LIMIT).then (loadedBuys)->
        _moreAvailable = loadedBuys.length == LIMIT
        buys.push loadedBuys...

    addNewBuy = (buys, buy)-> buys.unshift(buy)

    $scope.buys = []
    $scope.loadMore = load
    $scope.moreAvailable = moreAvailable

    #load the first set of buys
    load($scope.buys)

    $scope.$on 'buys:new', (event, buy)-> addNewBuy($scope.buys, buy)
]
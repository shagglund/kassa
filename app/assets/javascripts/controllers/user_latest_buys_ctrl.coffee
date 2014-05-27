angular.module('kassa').controller('UserLatestBuysCtrl', [
  '$scope'
  'UserService'
  'BuyService'
  ($scope, User, Buy)->
    LIMIT = 10
    _moreAvailable = true

    moreAvailable = -> _moreAvailable

    load = (user, buys)->
      return unless moreAvailable()
      Buy.latestForUser(user, offset: buys.length, limit: LIMIT).then (loadedBuys)->
        _moreAvailable = loadedBuys.length == LIMIT
        buys.push loadedBuys...

    setUserAndLoadBuys = (user)->
      $scope.user = user
      load(user, $scope.buys)

    loadMore = (buys)-> load($scope.user, buys)

    User.currentByRoute().then setUserAndLoadBuys

    $scope.buys = []
    $scope.loadMore = loadMore
    $scope.moreAvailable = moreAvailable
])
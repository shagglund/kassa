angular.module('kassa').controller('UserLatestBuysCtrl', [
  '$scope'
  'UserService'
  'BuyService'
  ($scope, User, Buy)->
    LIMIT = 10
    moreAvailable = null

    User.currentByRoute().then (user)->
      $scope.user = user
      Buy.latestForUser(user, limit: LIMIT).then (buys)->
        $scope.buys = buys

    loadMore = (buys)->
      Buy.latestForUser($scope.user, offset: buys.length, limit: LIMIT).then (loadedBuys)->
        moreAvailable = loadedBuys.length == LIMIT
        buys.push loadedBuys...

    moreAvailable = -> moreAvailable

    $scope.loadMore = loadMore
    $scope.moreAvailable = moreAvailable
])
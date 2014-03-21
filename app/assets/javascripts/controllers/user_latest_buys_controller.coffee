angular.module('kassa').controller('UserLatestBuysCtrl', [
  '$scope'
  'UserService'
  'BuyService'
  ($scope, User, Buy)->
    User.currentByRoute().then (user)->
      $scope.user = user
      Buy.latestForUser(user, 10).then (buys)->
        $scope.buys = buys
])
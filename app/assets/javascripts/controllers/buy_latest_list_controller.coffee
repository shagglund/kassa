angular.module('kassa').controller 'BuyLatestListController', [
  '$scope'
  '$location'
  'BuyService'
  ($scope, $location, Buy)->
    Buy.all(limit: 20).then (buys)-> $scope.buys = buys
]
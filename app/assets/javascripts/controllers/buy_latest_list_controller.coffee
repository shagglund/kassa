angular.module('kassa').controller 'BuyLatestListController', [
  '$scope'
  '$location'
  'BuyService'
  'BasketService'
  ($scope, $location, Buy, Basket)->
    Buy.all(limit: 20).then (buys)-> $scope.buys = buys
]
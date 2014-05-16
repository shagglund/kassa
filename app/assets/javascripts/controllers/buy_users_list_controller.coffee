angular.module('kassa').controller 'BuyUsersListController', [
  '$scope'
  'UserService'
  'BasketService'
  ($scope, User, Basket)->
    User.all().then (users)-> $scope.users = users
    $scope.basket = Basket
]
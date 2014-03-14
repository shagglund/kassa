angular.module('kassa').controller 'BuyUsersListController', [
  '$scope'
  '$location'
  'UserService'
  ($scope, $location, User)->
    User.all().then (users)-> $scope.users = users
]
angular.module('kassa').controller('UserListCtrl', [
  '$scope'
  'UserService'
  ($scope, User)->
    User.all().then (users)-> $scope.users = users
])
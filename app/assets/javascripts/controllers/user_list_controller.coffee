angular.module('kassa').controller('UserListCtrl', [
  '$scope'
  'UserService'
  'SessionService'
  ($scope, User, Session)->
    User.all().then (users)-> $scope.users = users
    $scope.session = Session
])
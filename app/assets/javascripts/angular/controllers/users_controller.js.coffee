angular.module('kassa.controllers.users', [])
.controller('UsersController', ($scope, $routeParams, DataService)->
  $scope.users = ->
    if angular.isDefined($scope.searchQuery) and $scope.searchQuery.length > 0
      exp = new RegExp($scope.searchQuery, 'i')
      _.select DataService.collection('users'), (u)->
        exp.test u.attributes.username
    else
      DataService.collection 'users'

  $scope.newUser = DataService.new 'user'

  if angular.isDefined $routeParams.id
    $scope.currentUser = DataService.find 'user', $routeParams.id
  else
    $scope.currentUser = $scope.newUser
)


uController =  ($scope, $routeParams, DataService)->
  $scope.users = ->
    if angular.isDefined($scope.filterQueries) and $scope.filterQueries.length > 0
      exps = (new RegExp(query,'i') for query in $scope.filterQueries)
      _.select DataService.collection('users'), (u)->
        return true for e in exps when e.test u.attributes.username
    else
      DataService.collection 'users'

  $scope.newUser = DataService.new 'user'

  if angular.isDefined $routeParams.id
    $scope.currentUser = DataService.find 'user', $routeParams.id
    if angular.isUndefined $scope.currentUser
      #hack to wait for users loading and then update the "found" user as current
      unregister = $scope.$watch 'users().length', ->
        $scope.currentUser = DataService.find 'user', $routeParams.id
        unregister() if angular.isDefined($scope.currentUser)
  else
    $scope.currentUser = $scope.newUser

angular.module('kassa.controllers.users', [])
.controller('UsersController',['$scope', '$routeParams', 'DataService', uController])

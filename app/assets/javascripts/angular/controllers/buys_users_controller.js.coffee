dependencies= [
  'kassa.services.basket'
  'kassa.services.data'
  'kassa.ui.dialogs.basket'
]
angular.module('kassa.controllers.buys.users', dependencies)
.controller('BuysUsersController', ($scope, Basket, DataService, BasketDialog)->
  $scope.basket = Basket
  $scope.dialog = BasketDialog
    
  $scope.users = ->
    if angular.isDefined($scope.filterQuery) and $scope.filterQuery.length > 0
      exp = new RegExp($scope.filterQuery, 'i')
      _.select DataService.collection('users'), (u)->
        exp.test u.attributes.username
    else
      DataService.collection('users')
  
  $scope.usernameContainsAny = (user, searchTerms)->
    return false unless angular.isObject(user)
    return false unless angular.isDdefined(searchTerms)
    return true if searchTerms.length == 0
    regExpList = (new RegExp(query, 'i') for query in searchTerms)
    return true for exp in regExpList when exp.test(user.attributes.username)
    
  $scope.iconByBalance = (balance)->
    if balance > 50
      'icon-briefcase'
    else if balance > 0
      'icon-star'
    else if balance > -25
      'icon-thumbs-down'
    else if balance > -50
      'icon-warning-sign'
    else if balance > -100
      'icon-fire'
    else
      'icon-ban-circle'
)

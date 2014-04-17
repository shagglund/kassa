angular.module('kassa').controller 'BalanceChangeLatestListCtrl', [
  '$scope'
  '$q'
  'UserService'
  'BalanceChangeService'
  ($scope, $q, User, BalanceChange)->
    balanceChanges = BalanceChange.all(User.currentByRoute()).then (loadedBalanceChanges)->
      $scope.balanceChanges = balanceChanges = loadedBalanceChanges
]
angular.module('kassa').controller 'BalanceChangeLatestListCtrl', [
  '$scope'
  'UserService'
  'BalanceChangeService'
  ($scope, User, BalanceChange)->
    loadBalanceChanges = ->
      BalanceChange.all(User.currentByRoute()).then (loadedBalanceChanges)->
        $scope.balanceChanges = loadedBalanceChanges

    $scope.$on 'user:balanceChange', loadBalanceChanges

    loadBalanceChanges()
]
angular.module('kassa').controller('UserDetailCtrl', [
  '$scope'
  'UserService'
  'SessionService'
  'StateService'
  ($scope, User, Session, State)->
    updateStateHandler = State.getHandler('UserDetailCtrl:updateState')
    balanceStateHandler = State.getHandler('UserDetailCtrl:balanceState')
    originalUser = null
    equal = angular.equals

    changed = (user)-> !equal(originalUser, user)


    copyUser = ->
      #copy to prevent any unsaved edits from leaking to server object state
      $scope.user = angular.copy(originalUser)

    save = (user)->
      promise = User.update(user).then(setUser)
      updateStateHandler.handleStateChanges(promise)

    setUser = (user)->
      originalUser = user
      copyUser()
      user

    newBalance = (euros=0, cents=0)-> (originalUser?.balance || 0) + euros + cents / 100

    clearBalanceChanges = ->
      delete $scope.balanceEuro
      delete $scope.balanceCent
      delete $scope.balanceChangeNote

    saveBalance = (user, newBalance, changeNote)->
      promise = User.updateBalance(user, newBalance, changeNote).then(setUser).then(clearBalanceChanges)
      balanceStateHandler.handleStateChanges(promise)

    balanceCanBeSaved = (euros=0, cents=0, changeNote='')->
      (euros != 0 || cents != 0) && !_.isEmpty(changeNote)

    User.currentByRoute().then setUser
    $scope.session = Session

    $scope.changed = changed
    $scope.cancel = copyUser
    $scope.save = save
    $scope.newBalance = newBalance
    $scope.saveBalance = saveBalance
    $scope.balanceCanBeSaved = balanceCanBeSaved

    $scope.state = updateStateHandler
    $scope.balanceState = balanceStateHandler
])
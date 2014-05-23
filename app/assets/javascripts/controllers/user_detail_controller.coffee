angular.module('kassa').controller('UserDetailCtrl', [
  '$scope'
  'UserService'
  'SessionService'
  ($scope, User, Session)->
    STATE_FAILED = 0
    STATE_SAVED = 1
    STATE_SAVING = 2
    STATE_DEFAULT = 3
    originalUser = null
    equal = angular.equals

    changed = (user)-> !equal(originalUser, user)


    cancel = ->
      #copy to prevent any unsaved edits from leaking to server object state
      $scope.user = angular.copy(originalUser)
      $scope.balance = {}

    save = (user)->
      saveSuccess = -> $scope.state = STATE_SAVED
      saveFailure = -> $scope.state = STATE_FAILED

      $scope.state = STATE_SAVING
      User.update(user).then(setUser).then saveSuccess, saveFailure

    setUser = (user)->
      originalUser = user
      cancel() #sets to default state by copying originalUser
      user

    newBalance = (euros=0, cents=0)-> (originalUser?.balance || 0) + euros + cents / 100

    saveBalance = (user, newBalance, changeNote)->
      saveSuccess = -> $scope.balanceState = STATE_SAVED
      saveFailure = -> $scope.balanceState = STATE_FAILED

      $scope.balanceState = STATE_SAVING
      User.updateBalance(user, newBalance, changeNote).then(setUser).then saveSuccess, saveFailure

    balanceCanBeSaved = (euros=0, cents=0, changeNote='')->
      (euros != 0 || cents != 0) && changeNote.length != 0

    User.currentByRoute().then setUser
    $scope.session = Session

    $scope.changed = changed
    $scope.cancel = cancel
    $scope.save = save
    $scope.newBalance = newBalance
    $scope.saveBalance = saveBalance
    $scope.balanceCanBeSaved = balanceCanBeSaved

    $scope.SAVED = STATE_SAVED
    $scope.FAILED = STATE_FAILED
    $scope.SAVING = STATE_SAVING
    $scope.DEFAULT = STATE_DEFAULT
])
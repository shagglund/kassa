angular.module('kassa').controller('UserNewCtrl', [
  '$scope'
  '$location'
  'UserService'
  ($scope, $location, User)->
    STATE_FAILED = 0
    STATE_SAVING = 1
    STATE_DEFAULT = 2

    cancel = ->
      $scope.user = {}
      $scope.newUserForm.$setPristine()

    save = (user)->
      goToUserProfile = (user)->
        $location.path("/users/#{user.id}")
      saveFailure = -> $scope.state = STATE_FAILED

      $scope.state = STATE_SAVING
      User.create(user).then(goToUserProfile, saveFailure)

    setBalance = (user, euros=0, cents=0)-> user.balance = euros + cents / 100

    passwordsMatch = (password, confirmation)-> password == confirmation

    $scope.cancel = cancel
    $scope.save = save
    $scope.setBalance = setBalance
    $scope.passwordsMatch = passwordsMatch

    $scope.FAILED = STATE_FAILED
    $scope.SAVING = STATE_SAVING
    $scope.DEFAULT = STATE_DEFAULT

    $scope.user = {}
])
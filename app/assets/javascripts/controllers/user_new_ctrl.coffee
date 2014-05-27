angular.module('kassa').controller('UserNewCtrl', [
  '$scope'
  '$location'
  'UserService'
  'StateService'
  ($scope, $location, User, State)->
    stateHandler = State.getHandler('UserNewCtrl:state')
    handleStateChanges = stateHandler.handleStateChanges
    newUser = -> {active: true}

    cancel = ->
      $scope.user = newUser()
      $scope.newUserForm.$setPristine()

    save = (user)->
      goToUserProfile = (user)->
        $location.path("/users/#{user.id}")
      handleStateChanges User.create(user).then(goToUserProfile)

    setBalance = (user, euros=0, cents=0)-> user.balance = euros + cents / 100

    passwordsMatch = (password, confirmation)-> password == confirmation

    $scope.cancel = cancel
    $scope.save = save
    $scope.setBalance = setBalance
    $scope.passwordsMatch = passwordsMatch

    $scope.state = stateHandler
    $scope.user = newUser()
])
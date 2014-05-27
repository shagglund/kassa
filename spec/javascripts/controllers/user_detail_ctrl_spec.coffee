describe 'UserDetailCtrl', ->
  [scope, User, Session] = [null, null, null]
  [equal, isObject, copy] = [angular.equals, angular.isObject, angular.copy]

  [user, updatedUser] = [{id: 1, username: 'default', balance: 10}, {id: 1, username: 'updated', balance: 10}]

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    User =
      currentByRoute: jasmine.createSpy('User.currentByRoute').andReturn($q.when(user)),
      updateBalance: jasmine.createSpy('User.updateBalance').andReturn($q.when(updatedUser)),
      update: jasmine.createSpy('User.update').andReturn($q.when(updatedUser))
    Session: {}
    $controller('UserDetailCtrl', $scope: scope, UserService: User, SessionService: Session)

  describe 'initialization', ->
    it "should assign session to scope.session", ->
      expect(scope.session).toBe(Session)

    it "should assign a StateHandler to scope.state", ->
      expect(scope.state.constructor.name).toBe('StateHandler')

    it "should assign a StateHandler to scope.balanceState", ->
      expect(scope.balanceState.constructor.name).toBe('StateHandler')

    it "should assign different state handlers to scope.state and scope.balanceState", ->
      expect(scope.state).toNotBe(scope.balanceState)

    it "should load the current user from route params", ->
      expect(User.currentByRoute).toHaveBeenCalled()
      scope.$apply()
      expect(equal(scope.user, user)).toBe(true)

  changeBalance = (user)->
    user.balance = (user.balance || 0) + 10

  describe 'scope.changed', ->
    beforeEach -> scope.$apply()

    it "should return true if the users aren't equal", ->
      changeBalance(user)
      expect(scope.changed(scope.user)).toBe(true)

    it "should return false if the users are equal", ->
      expect(scope.changed(scope.user)).toBe(false)

  describe 'scope.cancel', ->
    it "should reset any changes to the user", ->
      scope.$apply()
      expect(equal(scope.user, user)).toBe(true)
      changeBalance(scope.user)
      expect(equal(scope.user, user)).toBe(false)
      scope.cancel()
      expect(equal(scope.user, user)).toBe(true)

  describe 'scope.save', ->
    doSave = (apply=false)->
      scope.save()
      scope.$apply() if apply

    it "should set the updated user as scope.user on success", ->
      doSave(true)
      expect(equal(scope.user, updatedUser)).toBe(true)

    it "should set scope.state to changing", ->
      doSave()
      expect(scope.state.isChanging()).toBe(true)

    it "should set scope.state to success on success", ->
      doSave(true)
      expect(scope.state.isSuccess()).toBe(true)

    it "should set scope.state to error on failure", inject ($q)->
      User.update.andReturn($q.reject({}))
      doSave(true)
      expect(scope.state.isError()).toBe(true)

  describe 'scope.newBalance', ->
    it "should return the original users balance + given euros + given cents", ->
      scope.$apply()
      expect(scope.newBalance(10, 15)).toEqual(user.balance +  10.15)

  describe 'scope.saveBalance', ->
    newBalance = 10
    changeNote = 'test'
    saveBalance = (apply=false)->
      scope.saveBalance(scope.user, newBalance, changeNote)
      scope.$apply() if apply

    it "should update users balance", ->
      saveBalance()
      expect(User.updateBalance).toHaveBeenCalledWith(scope.user, newBalance, changeNote)

    it "should set the user to the updated user on success", ->
      saveBalance(true)
      expect(equal(scope.user, updatedUser)).toBe(true)

    it "should clean balance changes on success", ->
      scope.balanceEuro = newBalance
      scope.balanceCent = 10
      scope.balanceChangeNote = changeNote
      saveBalance(true)
      expect(scope.balanceEuro).toBeUndefined()
      expect(scope.balanceCent).toBeUndefined()
      expect(scope.balanceChangeNote).toBeUndefined()

    it "should change scope.balanceState to changing", ->
      saveBalance()
      expect(scope.balanceState.isChanging()).toBe(true)

    it "should change scope.balanceState to success on success", ->
      saveBalance(true)
      expect(scope.balanceState.isSuccess()).toBe(true)

    it "should change scope.balanceState to error on failure", inject ($q)->
      User.updateBalance.andReturn($q.reject({}))
      saveBalance(true)
      expect(scope.balanceState.isError()).toBe(true)

  describe 'scope.balanceCanBeSaved', ->
    it "should return true if change note and euros are given", ->
      expect(scope.balanceCanBeSaved(1, undefined, 'testnote')).toBe(true)

    it "should return true if change note and cents are given", ->
      expect(scope.balanceCanBeSaved(undefined, 1, 'testnote')).toBe(true)

    it "should return false if change note is missing or empty", ->
      expect(scope.balanceCanBeSaved(1, 1, undefined)).toBe(false)
      expect(scope.balanceCanBeSaved(1, 1, '')).toBe(false)

    it "should return false if change euros or cents are missing", ->
      expect(scope.balanceCanBeSaved(undefined, undefined, 'testnote')).toBe(false)


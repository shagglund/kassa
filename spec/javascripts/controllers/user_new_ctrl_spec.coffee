describe 'UserNewCtrl', ->
  [scope, location, User] = [null, null, null]
  isObject = angular.isObject

  user = id: 1, balance: 10

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    location = {path: jasmine.createSpy('$location.path')}
    User = {create: jasmine.createSpy('User.create').andReturn($q.when(user))}
    $controller('UserNewCtrl', $scope: scope, $location: location, UserService: User)

  describe 'initialization', ->
    it "should set scope.state to a StateHandler", ->
      expect(scope.state.constructor.name).toEqual('StateHandler')

    it "should setup a new active user", ->
      expect(isObject(scope.user)).toBe(true)
      expect(scope.user.active).toBe(true)

  describe 'scope.cancel', ->
    beforeEach inject ($compile)->
      #create and compile an actual form to assign newProductForm as a FormController on scope
      element = '<form name="newUserForm"></form>'
      $compile(element)(scope);

    it "should reset the user to a new active user", ->
      oldUser = scope.user
      scope.cancel()
      expect(isObject(scope.user)).toBe(true)
      expect(scope.user.active).toBe(true)
      expect(scope.user).toNotBe(oldUser)

    it "should reset the newUserForm to pristine state", ->
      spyOn(scope.newUserForm, '$setPristine')
      scope.cancel()
      expect(scope.newUserForm.$setPristine).toHaveBeenCalled()

  describe 'scope.save', ->
    doSave = (apply=false)->
      scope.save(scope.user)
      scope.$apply() if apply

    it "should create the new user", ->
      doSave()
      expect(User.create).toHaveBeenCalledWith(scope.user)

    it "should redirect to '/users/<newUserId>' (new users profile)", ->
      doSave(true)
      expect(location.path).toHaveBeenCalledWith("/users/#{user.id}")

    it "should set scope.state to changing", ->
      doSave()
      expect(scope.state.isChanging()).toBe(true)

    it "should set scope.state to success on success", ->
      doSave(true)
      expect(scope.state.isSuccess()).toBe(true)

    it "should set scope.state to error on failure", inject ($q)->
      User.create.andReturn($q.reject({}))
      doSave(true)
      expect(scope.state.isError()).toBe(true)

  describe 'scope.setBalance', ->
    it "should set the users balance to given euros and cents", ->
      user.balance = 10
      scope.setBalance(user, 15, 25)
      expect(user.balance).toEqual(15.25)

  describe 'scope.passwordsMatch', ->
    it "should return true if the passwords match", ->
      expect(scope.passwordsMatch('test','test')).toBe(true)

    it "should return false if the passwords don't match", ->
      expect(scope.passwordsMatch('test','fail')).toBe(false)

describe 'SessionService', ->
  [$httpBackend, $window, service, resolvePromises] = [null, null, null, null]
  [copy, equal] = [angular.copy, angular.equals]

  testUser = {id: 1, balance: 10}
  response = user: testUser

  beforeEach module 'kassa'
  beforeEach inject (_$httpBackend_, _$window_, $q, $injector, TestHelper)->
    $httpBackend = _$httpBackend_
    $httpBackend.when('GET', '/users/me').respond(response)
    resolvePromises = TestHelper.resolvePromises
    $window = _$window_
    service = $injector.get('SessionService')
    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe '#signIn', ->
    email = 'test@example.com'
    password = 'testpass'

    expectSignInRequest = (rememberMe)->
      $httpBackend.expect('POST', '/user/sign_in', user: {email, password, rememberMe}).respond(response)

    it "should send HTTP POST to /user/sign_in with email, password, rememberMe", ->
      expectSignInRequest(true)
      service.signIn(email, password)
      expectSignInRequest(false)
      service.signIn(email, password, false)
      $httpBackend.flush()

    it "should return the cached user unless changed", ->
      oldUser = service.currentUser(false)
      expectSignInRequest(true)
      service.signIn(email, password)
      $httpBackend.flush()
      expect(service.currentUser(false)).toBe(oldUser)

  describe '#signOut', ->
    doAndCheckSignOutRequest = ->
      $httpBackend.expectDELETE('/user/sign_out').respond(200)
      service.signOut()
      $httpBackend.flush()

    it "should send HTTP DELETE to /user/sign_out", ->
      doAndCheckSignOutRequest()

    it "should clear the authenticated user", ->
      expect(service.currentUser(false)).toBeDefined()
      doAndCheckSignOutRequest()
      expect(service.currentUser(false)).toBeUndefined()

    it "should redirect browser to /user/sign_in", ->
      spyOn($window.location, 'assign')
      doAndCheckSignOutRequest()
      expect($window.location.assign).toHaveBeenCalledWith('/user/sign_in')

  describe '#isCurrentUser', ->
    it "should return true if the user is equal to the currentUser", ->
      expect(service.isCurrentUser(testUser)).toBe(true)

    it "should return true if the user is not equal to the currentUser", ->
      newUser = copy(testUser)
      newUser.id++
      expect(service.isCurrentUser(newUser)).toBe(false)

  describe '#currentUser', ->
    it "should return the current user within a promise", ->
      resolvePromises ->
        service.currentUser().then (user)->
          expect(equal(user, testUser)).toBe(true)

    it "should return the current user without a promise if called with false", ->
      expect(equal(service.currentUser(false), testUser)).toBe(true)

  describe '#isAdmin', ->
    it "should return false by default", ->
      expect(service.isAdmin()).toBe(false)

    it "should return true if the current user is an admin", ->
      service.currentUser(false).admin = true
      expect(service.isAdmin()).toBe(true)

    it "should return false if the current user is not an admin", ->
      service.currentUser(false).admin = false
      expect(service.isAdmin()).toBe(false)

describe 'NavigationCtrl', ->
  [scope, Session] = [null, null]
  [VALID_TEST_PATH, INVALID_TEST_PATH] = ['/testpath', '/failpath']

  beforeEach module 'kassa'
  beforeEach inject ($controller, $rootScope)->
    scope = $rootScope.$new()
    Session = {}
    location = {path: jasmine.createSpy('$location.path').andReturn(VALID_TEST_PATH)}
    $controller('NavigationCtrl', $scope: scope, SessionService: Session, $location: location)

  describe 'initialization', ->
    it "should set Session to scope.session", ->
      expect(scope.session).toBe(Session)

  describe 'scope.isCurrent', ->
    it "should return true if current path == given path", ->
      expect(scope.isCurrent(VALID_TEST_PATH)).toBe(true)

    it "should return false if current path != given path", ->
      expect(scope.isCurrent(INVALID_TEST_PATH)).toBe(false)

    it "should match routes not starting with '/'", ->
      expect(scope.isCurrent(VALID_TEST_PATH.substring(1))).toBe(true)

    it "should match routes starting with '/'", ->
      expect(scope.isCurrent(VALID_TEST_PATH)).toBe(true)
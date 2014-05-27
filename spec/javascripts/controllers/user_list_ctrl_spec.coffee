describe 'UserListCtrl', ->
  [scope, Session, User] = [null, null, null]

  users = []

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    User = {all: jasmine.createSpy('User.all').andReturn($q.when(users))}
    Session = {}
    $controller('UserListCtrl', $scope: scope, UserService: User, SessionService: Session)

  describe 'initialization', ->
    it "should load all users", ->
      expect(User.all).toHaveBeenCalled()

    it "should assign all loaded users to scope.users", ->
      scope.$apply()
      expect(scope.users).toBe(users)

    it "should set Session to scope.session", ->
      expect(scope.session).toBe(Session)
describe 'UserLatestBuysCtrl', ->
  #limit has to match the one in the actual controller
  LIMIT = 10
  isArray = angular.isArray
  [scope, User, Buy] = [null, null, null]

  createBuyArray = (length = LIMIT - 1)-> {id: i} for i in [0..length-1]

  [buys, user] = [createBuyArray(LIMIT), {}]

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    User = {currentByRoute: jasmine.createSpy('User.currentByRoute').andReturn($q.when(user))}
    Buy = {latestForUser: jasmine.createSpy('Buy.latestForUser').andReturn($q.when(buys))}
    $controller('UserLatestBuysCtrl', $scope: scope, UserService: User, BuyService: Buy)

  describe 'initialization', ->
    it "should load the current user from User", ->
      expect(User.currentByRoute).toHaveBeenCalled()

    it "should load LIMIT latest buys for the current user", ->
      scope.$apply()
      expect(Buy.latestForUser).toHaveBeenCalledWith(user, jasmine.any(Object))
      expect(Buy.latestForUser.mostRecentCall.args[1].offset).toBe(0)
      expect(Buy.latestForUser.mostRecentCall.args[1].limit).toBe(LIMIT)

    it "should set the buys to an empty array", ->
      expect(isArray(scope.buys)).toBe(true)
      expect(scope.buys.length).toBe(0)

  describe 'scope.loadMore & scope.moreAvailable', ->
    loadBuys = (apply=false)->
      test = createBuyArray()
      scope.loadMore(test)
      scope.$apply() if apply
      test

    it "should load LIMIT more buys", ->
      loadBuys()
      expect(Buy.latestForUser.mostRecentCall.args[1].limit).toEqual(LIMIT)

    it "should have an offset of buys.length", ->
      test = loadBuys()
      expect(Buy.latestForUser.mostRecentCall.args[1].offset).toEqual(test.length)

    it "should set more available to true if loadedBuys.length == LIMIT", ->
      loadBuys(true)
      expect(scope.moreAvailable()).toBe(true)

    it "should set more available to false if loadedBuys.length != LIMIT", ->
      buys.splice(0, 1) #returns < LIMIT buys on Buy.latestForUser resolve
      loadBuys(true)
      expect(scope.moreAvailable()).toBe(false)

    it "should not load more if no more available", ->
      buys.splice(0, 1) #returns < LIMIT buys on Buy.latestForUser resolve
      scope.$apply()
      expect(scope.moreAvailable()).toBe(false)
      Buy.latestForUser.reset()
      loadBuys(false)
      expect(Buy.latestForUser).not.toHaveBeenCalled()


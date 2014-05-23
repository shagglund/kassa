describe 'BuyLatestListCtrl', ->
  #This should be exactly the same limit as in the real controller
  LIMIT = 20

  isArray = angular.isArray
  [scope, Buy, Basket] = [null, null, null]
  buys = []

  setupFakeBuyArray = (length=LIMIT-1)->
    if buys.length > length
      diff = buys.length - length
      buys.splice(length, diff)
    else
      buys.push {id: i} for i in [buys.length..length-1]

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    setupFakeBuyArray()
    scope = $rootScope.$new()
    deferred = $q.defer()
    deferred.resolve(buys)
    Buy = {latest: jasmine.createSpy('Buy.latest').andReturn(deferred.promise)}
    $controller('BuyLatestListCtrl', {$scope: scope, BuyService: Buy})

  describe 'initialization', ->
    it "should assign an empty array to scope.buys by default", ->
      expect(isArray(scope.buys)).toBe(true)

    it "should load LIMIT buys", ->
      expect(Buy.latest.mostRecentCall.args[0].limit).toEqual(LIMIT)

    it "should have an offset of 0", ->
      expect(Buy.latest.mostRecentCall.args[0].offset).toEqual(0)

    it "should add the loaded buys to scope.buys", ->
      expect(scope.buys.length).toNotEqual(buys.length)
      scope.$apply()
      expect(scope.buys.length).toEqual(buys.length)

  describe 'scope.moreAvailable()', ->
    it "should return true if loadedBuys.length == LIMIT", ->
      setupFakeBuyArray(LIMIT)
      scope.$apply()
      expect(scope.moreAvailable()).toBe(true)

    it "should return false if loadedBuys.length < LIMIT", ->
      scope.$apply()
      expect(scope.moreAvailable()).toBe(false)

  describe 'scope.loadMore()', ->

    beforeEach -> Buy.latest.reset()

    it "should not try to load more buys if there are no more buys available", ->
      scope.$apply()
      expect(scope.moreAvailable()).toBe(false)
      scope.loadMore([])
      expect(Buy.latest).not.toHaveBeenCalled()

    it "should load LIMIT buys", ->
      scope.loadMore([])
      scope.$apply()
      expect(Buy.latest.mostRecentCall.args[0].limit).toEqual(LIMIT)
      expect(scope.buys.length).toEqual(buys.length)

    it "should have an offset of current buys.length", ->
      scope.loadMore(buys)
      expect(Buy.latest.mostRecentCall.args[0].offset).toEqual(buys.length)

  describe 'event: buys:new', ->
    it "should add the new buy as first to the list", ->
      newBuy = id: 'new'
      expect(scope.buys[0]).toNotBe(newBuy)
      scope.$broadcast 'buys:new', newBuy
      expect(scope.buys[0]).toBe(newBuy)

describe 'BalanceChangeService', ->
  [$httpBackend, service, response] = [null, null, null]
  [equal, isFunction] = [angular.equals, angular.isFunction]

  TEST_DOER_ID = 1
  TEST_BALANCE_CHANGE_ID = 2

  beforeEach module 'kassa'
  beforeEach inject (_$httpBackend_, BalanceChangeService)->
    $httpBackend = _$httpBackend_
    service = BalanceChangeService
    response = doers: [{id: TEST_DOER_ID}], balanceChanges: [{id: TEST_BALANCE_CHANGE_ID, doerId: TEST_DOER_ID}]

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  doerFromResponse = -> response.doers[0]

  describe '#all', ->
    runTest = (resolveCallback, doerPromise)->
      $httpBackend.expectGET("/users/#{doerFromResponse().id}/balance_changes").respond(response)
      promise = service.all(doerPromise || doerFromResponse())
      promise.then(resolveCallback) if isFunction(resolveCallback)
      $httpBackend.flush()

    it "should work with user objects", ->
      runTest()

    it "should work with promises returning user objects", inject ($q)->
      runTest(null, $q.when(doerFromResponse()))

    it "should do a HTTP GET to '/users/<user.id>/balance_changes", ->
      runTest()

    it "should resolve each balance change doer from response", ->
      runTest (balanceChanges)->
        expect(equal(balanceChanges[0].doer, doerFromResponse())).toBe(true)

    it "should resolve the response promise to the balance changes", ->
      runTest (balanceChanges)->
        expect(balanceChanges[0].id).toEqual(TEST_BALANCE_CHANGE_ID)
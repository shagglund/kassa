describe 'StateService', ->
  [service, handler, helper]  = [null, null, null]

  #these need to match exactly the states defined in StateService,
  #do not expose those in StateService as they're not supposed to be
  #changeable when the application is running
  [STATE_ERROR, STATE_SUCCESS, STATE_CHANGING, STATE_DEFAULT] = [0,1,2,3]

  TEST_NEW_HANDLER_KEY = 'test:new'
  TEST_DEFAULT_HANDLER_KEY = 'test:default'

  beforeEach module 'kassa'
  beforeEach inject (StateService, TestHelper)->
    service = StateService
    helper = TestHelper
    handler = service.getHandler(TEST_DEFAULT_HANDLER_KEY)

  describe '#getHandler', ->
    it "should return a new StateHandler if one does not exist by key", ->
      testHandler = service.getHandler(TEST_NEW_HANDLER_KEY)
      expect(testHandler.constructor.name).toBe('StateHandler')
      expect(testHandler).toNotBe(handler)

    it "should return an existing StateHandler by key", ->
      testHandler = service.getHandler(TEST_NEW_HANDLER_KEY)
      expect(service.getHandler(TEST_NEW_HANDLER_KEY)).toBe(testHandler)


  describe 'StateHandler', ->
    describe 'new', ->
      it "should be in default state", ->
        expect(handler.__isInState(STATE_DEFAULT)).toBe(true)

    describe '#isError', ->
      it "should return true if in error state", ->
        handler.__setToState(STATE_ERROR)
        expect(handler.isError()).toBe(true)

      it "should return true if not in error state", ->
        handler.__setToState(STATE_SUCCESS)
        expect(handler.isError()).toBe(false)

    describe '#isSuccess', ->
      it "should return true if in success state", ->
        handler.__setToState(STATE_SUCCESS)
        expect(handler.isSuccess()).toBe(true)

      it "should return true if not in success state", ->
        handler.__setToState(STATE_ERROR)
        expect(handler.isSuccess()).toBe(false)

    describe '#isChanging', ->
      it "should return true if in changing state", ->
        handler.__setToState(STATE_CHANGING)
        expect(handler.isChanging()).toBe(true)

      it "should return true if not in changing state", ->
        handler.__setToState(STATE_ERROR)
        expect(handler.isChanging()).toBe(false)

    describe '#isDefault', ->
      it "should return true if in default state", ->
        handler.__setToState(STATE_DEFAULT)
        expect(handler.isDefault()).toBe(true)

      it "should return true if not in default state", ->
        handler.__setToState(STATE_ERROR)
        expect(handler.isDefault()).toBe(false)

    describe '#reset', ->
      it "should set the handler back to default state", ->
        handler.__setToState(STATE_ERROR)
        expect(handler.__isInState(STATE_DEFAULT)).toBe(false)
        handler.reset()
        expect(handler.__isInState(STATE_DEFAULT)).toBe(true)

    describe '#handleStateChanges', ->
      deferred = null
      beforeEach inject ($q)->
        deferred = $q.defer()
        handler.handleStateChanges(deferred.promise)

      it "should set current state to changing when called", ->
        expect(handler.__isInState(STATE_CHANGING)).toBe(true)

      it "should set current state to success if resolved", ->
        helper.instantResolve(deferred, {})
        expect(handler.__isInState(STATE_SUCCESS)).toBe(true)

      it "should set current state to error if rejected", ->
        helper.instantReject(deferred, {})
        expect(handler.__isInState(STATE_ERROR)).toBe(true)



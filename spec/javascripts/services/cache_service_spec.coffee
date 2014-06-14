describe 'BasketService', ->
  [service, resolvePromises, $q, testObj] = [null, null, null, null]

  [equal, isArray] = [angular.equals, angular.isArray]

  makeTestObj = -> id: 1

  beforeEach module 'kassa'
  beforeEach inject (CacheService, TestHelper, _$q_)->
    service = CacheService
    resolvePromises = TestHelper.resolvePromises
    $q = _$q_
    testObj = makeTestObj()

  describe '#set', ->
    it "should save the object", ->
      resolvePromises -> service.set(testObj)
      expect(service.isCached(testObj)).toBe(true)

    it "should save the object with given identity attribute",  inject ($parse)->
      identityFunc = $parse('name')
      identityFunc.assign(testObj, 'test')
      resolvePromises -> service.set(testObj, undefined, identityFunc)
      expect(service.isCached(testObj, undefined, identityFunc)).toBe(true)

    it "should save the object under given group prefix", ->
      prefix = 'test'
      resolvePromises -> service.set(testObj, prefix)
      expect(service.isCached(testObj)).toBe(false)
      expect(service.isCached(testObj, prefix)).toBe(true)

    it "should treat empty prefix as no prefix", ->
      prefix = ''
      resolvePromises -> service.set(testObj, prefix)
      expect(service.isCached(testObj)).toBe(true)

    it "should work with promises", ->
      resolvePromises -> service.set($q.when(testObj))
      expect(service.isCached(testObj)).toBe(true)

  describe '#get', ->

    it "should get the saved object", ->
      resolvePromises -> service.set(testObj)
      resolvePromises ->
        service.get(testObj).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

    it "should get the saved object with given identity func", inject ($parse)->
      identityFunc = $parse('name')
      identityFunc.assign(testObj, 'test')
      resolvePromises ->
        service.set(testObj, undefined, identityFunc)
      resolvePromises ->
        service.get(testObj, undefined, identityFunc).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

    it "should get the saved object under given group prefix", ->
      prefix = 'test'
      resolvePromises -> service.set(testObj, prefix)
      resolvePromises ->
        service.get(testObj, prefix).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

    it "should treat empty prefix as no prefix", ->
      prefix = ''
      resolvePromises -> service.set(testObj, prefix)
      resolvePromises ->
        service.get(testObj).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

  describe '#getByIdentity', ->
    [testIdentity, identityFunc] = [null, null]

    beforeEach inject ($parse)->
      testIdentity = 'test'
      identityFunc = $parse('name')
      identityFunc.assign(testObj, testIdentity)

    it "should get the saved object with given identity", ->
      resolvePromises ->
        service.set(testObj, undefined, identityFunc)
      resolvePromises ->
        service.getByIdentity(testIdentity).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

    it "should get the saved object under given group prefix", ->
      prefix = 'test'
      resolvePromises ->
        service.set(testObj, prefix, identityFunc)
      resolvePromises ->
        service.getByIdentity(testIdentity, prefix).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

    it "should treat empty prefix as no prefix", ->
      prefix = ''
      resolvePromises -> service.set(testObj, prefix)
      resolvePromises ->
        service.get(testObj).then (obj)->
          expect(equal(obj, testObj)).toBe(true)

  describe '#getAllByPrefix', ->
    it "should return all objects under given prefix", ->
      prefix = 'test'
      notIncludedObj = makeTestObj()
      resolvePromises ->
        service.set(testObj, prefix)
        service.set(notIncludedObj)
      resolvePromises ->
        service.getAllByPrefix(prefix).then (objects)->
          expect(objects.length).toBe(1)
          expect(equal(objects[0], testObj)).toBe(true)

    it "should return empty array if none cached under prefix", ->
      prefix = 'test'
      resolvePromises ->
        service.getAllByPrefix(prefix).then (objects)->
          expect(isArray(objects)).toBe(true)
          expect(objects.length).toBe(0)



describe 'Module kassa.common', ->
  $httpBackend = undefined
  item = undefined
  service = undefined
  options= {id: '@id'}
  actions =
    index:
      method: 'GET'
    create:
      method: 'POST'
    update:
      method: 'PUT'
    destroy:
      method: 'DELETE'
  success = jasmine.createSpy('success callback')
  failure = jasmine.createSpy('failure callback')
  beforeEach ->
    module 'kassa.common'
    inject ($injector)->
      $httpBackend = $injector.get '$httpBackend'
      ServiceFunc = $injector.get 'BaseService'
      service = new ServiceFunc('/items/:id', options, actions)
    item = {id: 1}
    success.reset()
    failure.reset()

  describe '#index',->
    items = ({id: i} for i in [1..3])
    beforeEach ->
      $httpBackend.expectGET('/items').respond 200, {collection: items}

    it 'returns a promise', ->
      spyOn service.resource, 'index'
      expect(angular.isDefined(service.index().then)).toBe true

    describe 'when server responds with success',->
      it 'adds all items to the cache collection', ->
        spy = spyOn service, '_add'
        service.index()
        $httpBackend.flush()
        expect(spy).toHaveBeenCalledWith(items...)

      it 'resolves the promise', ->
        service.index().then success, failure
        $httpBackend.flush()
        expect(success).toHaveBeenCalledWith(items)
        expect(failure).not.toHaveBeenCalled()

  describe '#create', ->
    beforeEach ->
      delete item['id'] #to appear unpersisted

    it 'encodes the item before sending the request', ->
      res_cr = spyOn service.resource, 'create'
      spy = spyOn(service, '_encode').andReturn 'test'
      service.create item
      expect(spy).toHaveBeenCalledWith item
      expect(res_cr.mostRecentCall.args[0]).toBe 'test'

    it 'returns a promise', ->
      spyOn service.resource, 'create'
      expect(angular.isDefined(service.create(item).then)).toBe true

    describe 'when server responds with success',->
      beforeEach ->
        $httpBackend.expectPOST("/items").respond 201, {object: item}

      it 'resolves the promise', ->
        service.create(item).then success, failure
        $httpBackend.flush()
        expect(success).toHaveBeenCalledWith(item)
        expect(failure).not.toHaveBeenCalled()

      it 'is added locally to the collection', ->
        spy = spyOn service, '_add'
        service.create item
        $httpBackend.flush()
        expect(spy).toHaveBeenCalledWith item
    
    describe 'when server responds with an error', ->
      beforeEach ->
        $httpBackend.expectPOST("/items").respond 422, {}
      
      it 'rejects the promise', ->
        service.create(item).then success, failure
        $httpBackend.flush()
        expect(success).not.toHaveBeenCalled()
        expect(failure).toHaveBeenCalled()

      it 'is not added locally to the collection', ->
        spy = spyOn service, '_add'
        service.create item
        $httpBackend.flush()
        expect(spy).not.toHaveBeenCalled()

  describe '#update', ->
    it 'returns a promise', ->
      spyOn service.resource, 'update'
      expect(angular.isDefined(service.update(item).then)).toBe true

    it 'encodes the item before sending the request', ->
      res_up = spyOn service.resource, 'update'
      spy = spyOn(service, '_encode').andReturn 'test'
      service.update item
      expect(spy).toHaveBeenCalledWith item
      expect(res_up.mostRecentCall.args[0]).toBe 'test'

    describe 'when server responds with success',->
      beforeEach ->
        $httpBackend.expectPUT("/items/#{item.id}").respond 204

      it 'resolves the promise', ->
        service.update(item).then success, failure
        $httpBackend.flush()
        expect(success).toHaveBeenCalledWith item
        expect(failure).not.toHaveBeenCalled()

      it 'updates the item locally if the server update succeeded', ->
        spy = spyOn service, '_update'
        service.update item
        $httpBackend.flush()
        expect(spy).toHaveBeenCalledWith item

    describe 'when server responds with an error', ->
      beforeEach ->
        $httpBackend.expectPUT("/items/#{item.id}").respond 422

      it 'rejects the promise', ->
        service.update(item).then success,failure
        $httpBackend.flush()
        expect(success).not.toHaveBeenCalled()
        expect(failure).toHaveBeenCalled()

      it 'does not update the item locally if the server update fails', ->
        spy = spyOn service, '_update'
        service.update item
        $httpBackend.flush()
        expect(spy).not.toHaveBeenCalled()

  describe '#destroy', ->
    it 'returns a promise', ->
      spyOn service.resource, 'destroy'
      expect(angular.isDefined(service.destroy(item).then)).toBe true

    describe 'when server responds with success',->
      beforeEach ->
        $httpBackend.expectDELETE("/items/#{item.id}").respond 204

      it 'resolves the promise', ->
        service.destroy(item).then success, failure
        $httpBackend.flush()
        expect(success).toHaveBeenCalledWith(item)
        expect(failure).not.toHaveBeenCalled()

      it 'removes the item locally if the server remove succeeded', ->
        spy = spyOn service, '_remove'
        service.destroy item
        $httpBackend.flush()
        expect(spy).toHaveBeenCalledWith item
    
    describe 'when server responds with an error', ->
      beforeEach ->
        $httpBackend.expectDELETE("/items/#{item.id}").respond 403

      it 'rejects the promise', ->
        service.destroy(item).then success, failure
        $httpBackend.flush()
        expect(success).not.toHaveBeenCalled()
        expect(failure).toHaveBeenCalled()

      it 'does not remove the item locally if the server remove fails',->
        spy = spyOn service, '_remove'
        service.destroy item
        $httpBackend.flush()
        expect(spy).not.toHaveBeenCalledWith item
      

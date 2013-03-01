describe 'Materials Module', ->
  describe 'Controllers', ->
    scope = undefined
    beforeEach module 'kassa.materials'
    beforeEach inject ($rootScope)->
      scope = $rootScope.$new()

    describe 'MaterialsController', ->
      controller = undefined
      beforeEach inject ($controller)->
        controller = $controller 'MaterialsController', {$scope: scope}
      

  describe 'Services', ->
    describe 'Materials', ->
      service = undefined
      $httpBackend = undefined
      beforeEach ->
        module 'kassa.materials'
        inject ($injector)->
          service = $injector.get 'Materials'
          $httpBackend = $injector.get '$httpBackend'

      describe 'server interaction', ->
        success = jasmine.createSpy()
        failure = jasmine.createSpy()
        material = undefined
        beforeEach ->
          material = Factory.build 'material'
          success.reset()
          failure.reset()
      
        describe '#create', ->
          beforeEach ()->
            delete material['id'] #to make the material appear unpersisted

          it 'creates a valid material', ->
            $httpBackend.expectPOST('/materials').respond 201,  {object: material}
            service.create(material).then success, failure
            $httpBackend.flush()
            expect(success).toHaveBeenCalled()
            expect(failure).not.toHaveBeenCalled()

          it 'fails if the material is invalid', ->
            $httpBackend.expectPOST('/materials').respond 422, {}
            service.create(material).then success, failure
            $httpBackend.flush()
            expect(success).not.toHaveBeenCalled()
            expect(failure).toHaveBeenCalled()
          
        describe '#destroy', ->
          it 'deletes the material', ->
            $httpBackend.expectDELETE("/materials/#{material.id}").respond 204, ''
            service.destroy(material).then(success, failure)
            $httpBackend.flush()
            expect(success).toHaveBeenCalled()
            expect(failure).not.toHaveBeenCalled()

        describe '#update', ->
          it 'updates a valid material',->
            $httpBackend.expectPUT("/materials/#{material.id}").respond 200,''
            service.update(material).then success, failure
            $httpBackend.flush()
            expect(success).toHaveBeenCalled()
            expect(failure).not.toHaveBeenCalled()

          it 'fails if the material is invalid', ->
            $httpBackend.expectPUT("/materials/#{material.id}").respond 422, {}
            service.update(material).then success, failure
            $httpBackend.flush()
            expect(success).not.toHaveBeenCalled()
            expect(failure).toHaveBeenCalled()

        describe '#index', ->
          it 'returns an array of materials', ->
            materials = Factory.build 'material' for i in [0..2]
            $httpBackend.expectGET("/materials").respond 200, {collection: materials}
            service.index().then success, failure
            $httpBackend.flush()
            expect(success).toHaveBeenCalled()

        describe '#updateChanged', ->
          it 'updates the existing material in the collection', ->
            service._add material
            m = angular.copy material
            m.price = material.price += 1
            service.updateChanged m
            expect(service.collection[0].price).toBe m.price
            
          it 'can update multiple materials from an array',->
            materials = (Factory.build 'material' for i in [0..2])
            service._add mat for mat in materials
            for mat,i in materials
              do (mat,i)->
                copy = angular.copy mat
                copy.price = mat.price += 1
                materials[i] = copy
            expect(service.collection[i].price).toBe materials[i].price for mat, i in service.collection


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
      material = undefined
      beforeEach ->
        module 'kassa.materials'
        inject ($injector)->
          service = $injector.get 'Materials'
        material = Factory.build 'material'

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

      describe 'BaseService inheritance', ->
        it 'is an instance of BaseService', inject (BaseService)->
          expect(service instanceof BaseService).toBeTruthy()

        it 'has an #index method', ->
          expect(service.index).toBeDefined()

        it 'has a #create method', ->
          expect(service.create).toBeDefined()

        it 'has an #update method', ->
          expect(service.update).toBeDefined()

        it 'has an #destroy method', ->
          expect(service.destroy).toBeDefined()

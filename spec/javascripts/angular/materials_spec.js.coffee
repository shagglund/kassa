describe 'Materials Module', ->
  beforeEach module 'kassa.materials'
  describe 'Controllers', ->
    scope = undefined
    beforeEach inject ($rootScope)->
      scope = $rootScope.$new()

    describe 'MaterialsController', ->
      controller = undefined
      beforeEach inject ($controller)->
        controller = $controller 'MaterialsController', {$scope: scope}
      

  describe 'Materials service', ->
    material = undefined
    beforeEach ->
      material = Factory.build 'material'

    describe '#updateChanged', ->
      it 'updates the existing material in the collection', inject (Materials)->
        Materials._add material
        m = angular.copy material
        m.price = material.price += 1
        Materials.updateChanged m
        expect(Materials.collection[0].price).toBe m.price
        
      it 'can update multiple materials from an array',inject (Materials)->
        materials = (Factory.build 'material' for i in [0..2])
        Materials._add mat for mat in materials
        for mat,i in materials
          do (mat,i)->
            copy = angular.copy mat
            copy.price = mat.price += 1
            materials[i] = copy
        expect(Materials.collection[i].price).toBe materials[i].price for mat, i in Materials.collection

    describe 'BaseService inheritance', ->
      it 'is an instance of BaseService', inject (BaseService, Materials)->
        expect(Materials instanceof BaseService).toBeTruthy()

      it 'has an #index method', inject (Materials)->
        expect(Materials.index).toBeDefined()

      it 'has a #create method', inject (Materials)->
        expect(Materials.create).toBeDefined()

      it 'has an #update method', inject (Materials)->
        expect(Materials.update).toBeDefined()

      it 'has an #destroy method', inject (Materials)->
        expect(Materials.destroy).toBeDefined()

describe 'Products module', -> 
  describe 'Products service', ->
    service = undefined
    beforeEach ->
      module 'kassa.products'
      inject ($injector)->
        service = $injector.get 'Products'

    describe '#stockOf', ->
      it 'should return the materials stock / amount required for the product', ->
        m1 = Factory.build 'material', {stock:1}
        product = Factory.build 'product', {materials:  [{material: m1, amount:1}]}
        expect(service.stockOf product).toBe 1

      it 'should return the smallest stock from multiple materials', ->
        m1 = Factory.build 'material', {stock: 3}
        m2 = Factory.build 'material', {stock: 4}
        product = Factory.build 'product', {materials: [{material: m1, amount: 1}, {material: m2, amount:2}]}
        expect(service.stockOf product).toBe 2

    describe '#priceOf', ->
      it 'returns the price of the material * amount required for making the product', ->
        m = Factory.build 'material', {price: 1}
        product =Factory.build 'product', {materials: [{material: m, amount: 2}]}
        expect(service.priceOf product).toBeCloseTo 2, 0.001

      it 'returns the sum of the material prices * amounts required for making the product', ->
        m1 = Factory.build 'material', {price: 0.7}
        m2 = Factory.build 'material', {price: 1}
        product = Factory.build 'product', {materials: [{material: m1, amount:1}, {material: m2, amount:2}]}
        expect(service.priceOf product).toBeCloseTo 2.7, 0.001

    describe '#_addSingle',->
      it 'binds the materials by ids using Materials service', ->
        m = Factory.build 'material'
        product = Factory.build 'product', {materials: [{material: m.id, amount:1}]}
        spy = spyOn(service.materialService, 'findById').andReturn m
        service._addSingle product
        expect(product.materials[0].material).toBe m
        expect(spy).toHaveBeenCalledWith m.id

      it 'doesn\'t try to bind materials that are already bound', ->
        product = Factory.build 'product'
        spy = spyOn(service.materialService, 'findById')
        service._addSingle product
        expect(spy).not.toHaveBeenCalled()

      it 'adds the product to the collection', ->
        product = Factory.build 'product'
        service._addSingle product
        expect(service.entries()).toContain(product)

    describe '#_encode', ->
      it 'returns a rails record compatible object', ->
        obj = service._encode Factory.build 'product'
        allowed = ['name','id','description','unit','group','materials_attributes']
        expect(allowed).toContain(prop) for prop of obj when obj.hasOwnProperty(prop)

    describe 'BaseService inheritance', ->
      it 'is an instance of BaseService', inject (BaseService)->
        expect(service instanceof BaseService).toBeTruthy()

      it 'has an #index method from BaseService', ->
        expect(service.index).toBeDefined()

      it 'has a #create method from BaseService', ->
        expect(service.create).toBeDefined()

      it 'has a #update method from BaseService', ->
        expect(service.update).toBeDefined()

      it 'has a #destroy method from BaseService', ->
        expect(service.destroy).toBeDefined()

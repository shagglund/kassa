describe 'Products module', ->
  context = {}
  beforeEach ->
    module 'kassa.products'
  afterEach ->
    #hack so won't need to specify variables as undefined for coffeescript scoping
    context = {}

  describe 'Products service', ->
    describe '#stockOf', ->
      it 'should return the materials stock / amount required for the product', inject (Products)->
        m1 = Factory.build 'material', {stock:1}
        product = Factory.build 'product', {materials:  [{material: m1, amount:1}]}
        expect(Products.stockOf product).toBe 1

      it 'should return the smallest stock from multiple materials', inject (Products)->
        m1 = Factory.build 'material', {stock: 3}
        m2 = Factory.build 'material', {stock: 4}
        product = Factory.build 'product', {materials: [{material: m1, amount: 1}, {material: m2, amount:2}]}
        expect(Products.stockOf product).toBe 2

    describe '#priceOf', ->
      it 'returns the price of the material * amount required for making the product', inject (Products)->
        m = Factory.build 'material', {price: 1}
        product =Factory.build 'product', {materials: [{material: m, amount: 2}]}
        expect(Products.priceOf product).toBeCloseTo 2, 0.001

      it 'returns the sum of the material prices * amounts required for making the product', inject (Products)->
        m1 = Factory.build 'material', {price: 0.7}
        m2 = Factory.build 'material', {price: 1}
        product = Factory.build 'product', {materials: [{material: m1, amount:1}, {material: m2, amount:2}]}
        expect(Products.priceOf product).toBeCloseTo 2.7, 0.001

    describe '#_handleRawResponse', ->
      it 'should update materials to materials service on index load', inject (Materials, Products)->
        response =
          collection:[]
          materials: (Factory.build 'material' for i in [0..2])
        spy = spyOn(Materials, 'updateChanged')
        Products._handleRawResponse 'index', response
        expect(spy).toHaveBeenCalledWith response.materials...

    describe '#_addSingle',->
      it 'binds the materials by ids using Materials service', inject (Products)->
        m = Factory.build 'material'
        product = Factory.build 'product', {materials: [{material: m.id, amount:1}]}
        spy = spyOn(Products.materialService, 'findById').andReturn m
        Products._addSingle product
        expect(product.materials[0].material).toBe m
        expect(spy).toHaveBeenCalledWith m.id

      it 'doesn\'t try to bind materials that are already bound', inject (Products)->
        product = Factory.build 'product'
        spy = spyOn(Products.materialService, 'findById')
        Products._addSingle product
        expect(spy).not.toHaveBeenCalled()

      it 'adds the product to the collection', inject (Products)->
        product = Factory.build 'product'
        Products._addSingle product
        expect(Products.entries()).toContain(product)

    describe '#_encode', ->
      beforeEach inject (Products)->
        context.product = Factory.build 'product'
        console.log Products._encode
        context.encoded = Products._encode context.product
        context.allowed = ['name','id','description','unit','group','consists_of_materials_attributes']

      it 'should add the id as encoded.id if present', inject (Products)->
        expect(context.encoded.id).toBe context.product.id

      it 'should add the product information in encoded.product for rails', inject (Products)->
        expect(context.encoded.product).toBeDefined()

      it 'should only encode changeable properties', inject (Products)->
        expect(context.allowed).toContain(prop) for own prop of context.encoded.product

    describe 'BaseService inheritance', ->
      it 'is an instance of BaseService', inject (BaseService, Products)->
        expect(Products instanceof BaseService).toBeTruthy()

      it 'has an #index method from BaseService', inject (Products)->
        expect(Products.index).toBeDefined()

      it 'has a #create method from BaseService', inject (Products)->
        expect(Products.create).toBeDefined()

      it 'has a #update method from BaseService', inject (Products)->
        expect(Products.update).toBeDefined()

      it 'has a #destroy method from BaseService', inject (Products)->
        expect(Products.destroy).toBeDefined()
  
  describe 'Controllers', ->
    scope = undefined
    beforeEach ->
      inject ($rootScope)->
        scope = $rootScope.$new()

    describe 'ProductsController', ->
      controller = undefined
      beforeEach inject ($controller)->
        controller = $controller 'ProductsController', {$scope: scope}

      it 'should bind products service to the scope', inject (Products)->
        expect(scope.products).toBe Products
    

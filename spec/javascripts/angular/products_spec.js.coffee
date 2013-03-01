describe 'Products module', ->
  
  describe 'Products service', ->
    $httpBackend = undefined
    service = undefined
    beforeEach ->
      module 'kassa.products'
      inject ($injector)->
        service = $injector.get 'Products'
        $httpBackend = $injector.get '$httpBackend'

    describe '#stockOf', ->
      it 'should return the materials stock / amount required for the product', ->
        m1 = Factory.build 'material', {stock:1}
        product = Factory.build 'product', {materials:  [{material: m1, amount:1}]}
        expect(service.stockOf(product)).toBe 1

      it 'should return the smallest stock from multiple materials', ->
        m1 = Factory.build 'material', {stock: 3}
        m2 = Factory.build 'material', {stock: 4}
        product = Factory.build 'product', {materials: [{material: m1, amount: 1}, {material: m2, amount:2}]}
        expect(service.stockOf(product)).toBe 2

    describe '#priceOf', ->
      it 'returns the price of the material * amount required for making the product', ->
        m = Factory.build 'material', {price: 1}
        product =Factory.build 'product', {materials: [{material: m, amount: 2}]}
        expect(service.priceOf(product)).toBe (2).toFixed(2)

      it 'returns the sum of the material prices * amounts required for making the product', ->
        m1 = Factory.build 'material', {price: 0.7}
        m2 = Factory.build 'material', {price: 1}
        product = Factory.build 'product', {materials: [{material: m1, amount:1}, {material: m2, amount:2}]}
        expect(service.priceOf(product)).toBe (2.70).toFixed(2)
        
    describe 'with valid product', ->

    describe 'with invalid product', ->


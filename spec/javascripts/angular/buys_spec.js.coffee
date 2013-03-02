describe 'Module kassa.buys', ->
  beforeEach ->
    module 'kassa.buys'

  describe 'Controllers', ->
    scope = undefined
    beforeEach inject ($rootScope)->
      scope = $rootScope.$new()

    describe 'BuysController', ->
      controller = undefined
      beforeEach inject ($controller)->
        controller = $controller 'BuysController', {$scope: scope}
      
      it 'should bind Buys-service to the scope ', inject (Buys)->
        expect(scope.buys).toBe(Buys)

    describe 'BasketController', ->
      controller = undefined
      beforeEach inject ($controller)->
        controller = $controller 'BasketController', {$scope: scope}

      it 'should bind basket to scope', inject (Basket)->
        expect(scope.basket).toBe(Basket)
    
      it 'should be able to tell how many pieces of a product can be bought', inject (Products)->
        amount = 15
        spyOn(Products,'stockOf').andReturn amount
        product = Factory.build 'product'
        expect(scope.maxBuyable(product)).toBe amount
        expect(Products.stockOf).toHaveBeenCalledWith product
      
      it 'should be able to find a buyer by username', inject (Users, Basket)->
        user = Factory.build 'user'
        spyOn(Users, 'findByUsername').andReturn(user)
        scope.setBuyerByName(user.username)
        expect(Users.findByUsername).toHaveBeenCalledWith(user.username)
        expect(Basket.buyer).toBe(user)

  describe 'Basket', ->
    product = undefined
    beforeEach ->
      product = Factory.build 'product'

    it 'should keep a list of the products in basket', inject (Basket)->
      Basket.add Factory.build 'product'
      expect(Basket.entries().length).toBe 1

    describe '#add', ->
      it 'can add products', inject (Basket)->
        Basket.add product
        expect(Basket._products[0].product).toEqual product
    
      it 'adding already existing products again increments their amount', inject (Basket)-> 
        Basket.add product for num in [0..1] 
        expect(Basket._products[0].amount).toEqual 2

    describe '#remove', ->
      it 'can remove products', inject (Basket)->
        Basket.add product
        Basket.remove product
        expect(Basket.entries().length).toBe 0
      
      it 'removes only a single product, aka decrements the product amount', inject (Basket)->
        Basket.add product for num in [0..2]
        Basket.remove product
        expect(Basket._products[0].amount).toBe 2
  
    describe '#removeAll', ->
      it 'removes all entries of a single product on removeAll(product)', inject (Basket)->
        Basket.add product for i in [0..2]
        Basket.removeAll product
        expect(Basket.hasProduct(product)).toBe false
      
      it 'removes all products on removeAll()', inject (Basket)->
        Basket.add Factory.build 'product' for i in [0..2]
        Basket.removeAll()
        expect(Basket._products.length).toBe 0
    
    describe '#clear', ->
      it 'removes all products on clear',inject (Basket)->
        Basket.clear()
        expect(Basket._products.length).toBe 0
    
    describe '#hasProduct', ->
      it 'should tell whether a product is in basket or not', inject (Basket)->
        Basket.add product
        expect(Basket.hasProduct(product)).toBe true
    
    describe '#productCount', ->
      it 'should tell the total of products in basket', inject (Basket)->
        Basket.add product for i in [0..2]
        Basket.add Factory.build 'product'
        expect(Basket.productCount()).toBe 4

    describe '#setBuyer', ->
      it 'can set the buyer', inject (Basket)->
        expect(angular.isDefined(Basket.buyer)).toBe false
        Basket.setBuyer Factory.build 'user'
        expect(Basket.hasBuyer()).toBe true
      
      it 'should be able to tell if a specific user is the buyer', inject (Basket)->
        user = Factory.build 'user'
        Basket.setBuyer user
        expect(Basket.isBuyer(user)).toBe true

    describe '#clearBuyer', ->
      it 'can clear the buyer', inject (Basket)->
        user = Factory.build 'user'
        Basket.setBuyer user
        expect(Basket.hasBuyer()).toBe true
        Basket.clearBuyer()
        expect(Basket.hasBuyer()).toBe false
        
    describe 'valid basket', ->
      it 'all products should have amounts >= 1', inject (Basket)->
        Basket.add product
        expect(Basket.hasValidProducts()).toBe true
        Basket._products[0].amount = 0
        expect(Basket.hasValidProducts()).toBe false
      
      it 'user should be selected', inject (Basket)->
        expect(Basket.hasValidBuyer()).toBe false
        Basket.buyer = Factory.build 'user'
        expect(Basket.hasValidBuyer()).toBe true
      
      it 'all products should have amounts <= their stock', inject (Basket)->
        e.material.stock = e.amount for e in product.materials
        Basket.add product
        expect(Basket.hasValidProducts()).toBe true
        
      it 'can be bought', inject (Basket)->
        Basket.add product
        Basket.setBuyer Factory.build 'user'
        expect(Basket.valid()).toBe true

    describe 'invalid basket', ->
      it 'has product(s) with amount < 1', inject (Basket)->
        Basket.add product
        Basket._products[0].amount = 0
        expect(Basket.hasValidProducts()).toBe false

      it 'has more product(s) than in stock', inject (Basket)->
        e.material.stock = e.amount-=1 for e in product.materials
        Basket.add product
        expect(Basket.hasValidProducts()).toBe false

      it 'doesn\'t have a buyer', inject (Basket)->
        Basket.setBuyer undefined
        expect(Basket.hasValidBuyer()).toBe false
      
      it 'cannot be bought when products are invalid', inject (Basket)->
        spyOn(Basket,'hasValidProducts').andReturn false
        expect(Basket.valid()).toBe false

      it 'cannot be bought when buyer is invalid', inject (Basket)->
        spyOn(Basket,'hasValidBuyer').andReturn false
        expect(Basket.valid()).toBe false

  describe 'Buys', ->
    describe '#create', ->
      user = Factory.build 'user'
      fakeResponse =
        object: Factory.build('buy', {buyer: user})
        materials: []
        buyer: user

      it 'calls the Materials-service to update the changed materials', inject ($httpBackend, Buys, Materials)->
        $httpBackend.expectPOST('/buys').respond 201, fakeResponse
        spyOn(Materials, 'updateChanged').andCallThrough()
        Buys.create Factory.build 'buy'
        $httpBackend.flush()
        expect(Materials.updateChanged).toHaveBeenCalledWith(fakeResponse.materials)

      it 'calls the Users-service to update the changed user', inject ($httpBackend, Buys, Users)->
        $httpBackend.expectPOST('/buys').respond 201, fakeResponse
        spyOn(Users, 'updateChanged').andCallThrough()
        Buys.create Factory.build 'buy'
        $httpBackend.flush()
        expect(Users.updateChanged).toHaveBeenCalledWith(fakeResponse.buyer)

        

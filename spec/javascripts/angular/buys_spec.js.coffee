describe 'Module kassa.buys', ->
  describe 'Controllers', ->
    scope = undefined
    beforeEach module 'kassa.buys'
    beforeEach inject ($rootScope)->
      scope = $rootScope.$new()

    describe 'BuysController', ->
      controller = undefined
      buys = undefined
      beforeEach inject ($controller)->
        buys = {}
        controller = $controller 'BuysController', {$scope: scope, Buys: buys}
      
      it 'should bind Buys-service to the scope ', ()->
        expect(scope.buys).toBe(buys);

    describe 'BasketController', ->
      controller = undefined
      basket = undefined
      products = undefined
      users = undefined
      beforeEach inject ($controller)->
        users = 
          findByUsername: ()->
        basket =
          _products: {}
        products=
          stockOf: ()->
            1
          priceOf: ()->
            1
        controller = $controller 'BasketController', {
          $scope: scope,
          Basket: basket,
          Users: users,
          Products: products
        }
      it 'should bind basket to scope', ()->
        expect(scope.basket).toBe(basket)
    
      it 'should be able to tell how many pieces of a product can be bought', ()->
        amount = 15
        spyOn(products,'stockOf').andReturn amount
        product = Factory.build 'product'
        expect(scope.maxBuyable(product)).toBe amount
        expect(products.stockOf).toHaveBeenCalledWith product
      
      it 'should be able to find a buyer by username', ()->
        user = Factory.build 'user'
        spyOn(users, 'findByUsername').andReturn(user)
        scope.setBuyerByName(user.username)
        expect(users.findByUsername).toHaveBeenCalledWith(user.username)
        expect(basket.buyer).toBe(user)    
      
      it 'should be able to show the basket'      
      it 'should be able to be bought'
      it 'should be able to clear the basket (remove the buyer & products)'
      it 'should be able to close the modal window without any changes'

  describe 'Basket', ->
    basket = undefined
    products = undefined
    buys = undefined
    beforeEach ->
      module 'kassa.buys', ($provide)-> 
        $provide.service 'Buys', ()->
          buys = {}
        $provide.service 'Products', ()->
          products = {priceOf: jasmine.createSpy(), stockOf: jasmine.createSpy()}
          products.priceOf.andCallFake (product)->
            price = 0.00
            for mat in product.materials 
              do (mat)->
                price+= mat.price
            price.toFixed(2)
          products.stockOf.andCallFake (product)->
            min = -1
            for mat in product.materials 
              do (mat)->
                if mat.stock < min or min is -1
                  min = mat.stock
            min
          products
        return
      inject ($injector)->
        basket = $injector.get 'Basket'
   
    it 'should keep a list of the products in basket', ->
      basket.add Factory.build 'product'
      expect(basket.entries().length).toBe 1
      
    describe 'adding and removing products', ->
      product=undefined
      beforeEach ()->
        product = Factory.build('product')
      it 'can add products', ->
        basket.add product
        expect(basket._products[0].product).toEqual product
    
      it 'adding already existing products again increments their amount', -> 
        basket.add product for num in [0..1] 
        expect(basket._products[0].amount).toEqual 2

      it 'can remove products', ->
        basket.add product
        basket.remove product
        expect(basket._products.length).toBe 0
      
      it 'removes only a single product, aka decrements the product amount', ->
        basket.add product for num in [0..2]
        basket.remove product
        expect(basket._products[0].amount).toBe 2

      it 'removes all entries of a single product on removeAll(product)', ->
        basket.add product for num in [0..2]
        basket.removeAll product
        expect(basket._products.indexOf(product)).toBe -1
      
      it 'removes all products on removeAll()', ->
        basket.add product
        basket.add Factory.build 'product'
        basket.removeAll()
        expect(basket._products.length).toBe 0

      it 'removes all products on clear',->
        basket.add product
        basket.clear()
        expect(basket._products.length).toBe 0
      
      it 'should tell whether a product is in basket or not', ->
        basket.add product
        expect(basket.hasProduct(product)).toBe true
      
      it 'should tell the total of products in basket', ->
        basket.add product for i in [0..2]
        basket.add Factory.build 'product'
        expect(basket.productCount()).toBe 4

    describe 'setting and removing buyer', ->
      it 'can set the buyer', ->
        expect(angular.isDefined(basket.buyer)).toBe false
        basket.setBuyer Factory.build 'user'
        expect(basket.hasBuyer()).toBe true
      
      it 'should be able to tell if a specific user is the buyer', ->
        user = Factory.build 'user'
        basket.setBuyer user
        expect(basket.isBuyer(user)).toBe true
      
      it 'can clear the buyer', ()->
        user = Factory.build 'user'
        basket.setBuyer user
        expect(basket.hasBuyer()).toBe true
        basket.clearBuyer()
        expect(basket.hasBuyer()).toBe false
        
    describe 'valid basket', ->
      product = undefined
      beforeEach ->
        product = Factory.build 'product'

      it 'all products should have amounts >= 1', ->
        basket.add product
        expect(basket.hasValidProducts()).toBe true
        basket._products[0].amount = 0
        expect(basket.hasValidProducts()).toBe false
      
      it 'user should be selected', ->
        expect(basket.hasValidBuyer()).toBe false
        basket.buyer = Factory.build 'user'
        expect(basket.hasValidBuyer()).toBe true
      
      it 'all products should have amounts <= their stock', ->
        products.stockOf.andReturn(100)
        basket.add product
        expect(basket.hasValidProducts()).toBe true
        
      it 'can be bought', ->
        basket.add product
        basket.setBuyer Factory.build 'user'
        expect(basket.valid()).toBe true

    describe 'invalid basket', ->
      product = undefined
      beforeEach ->
        product = Factory.build 'product'

      it 'has product(s) with amount < 1', ()->
        basket.add product
        basket._products[0].amount = 0
        expect(basket.hasValidProducts()).toBe false

      it 'has more product(s) than in stock', ()->
        products.stockOf.andReturn 0
        basket.add product
        expect(basket.hasValidProducts()).toBe false

      it 'doesn\'t have a buyer', ()->
        basket.setBuyer undefined
        expect(basket.hasValidBuyer()).toBe false
      
      it 'cannot be bought when products are invalid', ()->
        spyOn(basket,'hasValidProducts').andReturn false
        expect(basket.valid()).toBe false

      it 'cannot be bought when buyer is invalid', ()->
        spyOn(basket,'hasValidBuyer').andReturn false
        expect(basket.valid()).toBe false

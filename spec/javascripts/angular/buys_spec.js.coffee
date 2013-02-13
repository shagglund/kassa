describe 'Module Kassa.Buys', ->
  describe 'Controllers', ->
    scope = undefined
    beforeEach module 'Kassa.Buys'
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
        users = {}
        basket = 
          chosenProducts: {}
        products= {}
        controller = $controller 'BasketController', {
          $scope: scope,
          Basket: basket,
          Users: users,
          Products: products
        }
      it 'should bind basket to scope', ()->
        expect(scope.basket).toBe(basket)

      it 'should provide a list of added products', ()->
        expect(scope.entries).toBe basket.chosenProducts

      it 'can increment the amount of product in basket', ()->
        product = {}
        basket.add = jasmine.createSpy()
        scope.add product
        expect(basket.add).toHaveBeenCalledWith(product)

      it 'can decrement the amount of a product in basket', ()->
        product = {}
        basket.remove=jasmine.createSpy()
        scope.remove product
        expect(basket.remove).toHaveBeenCalledWith(product, false)

      it 'should be able to tell if there are any products in the basket', ()->
        spy= basket.productCount= jasmine.createSpy()
        spy.andReturn(0)
        expect(scope.hasSelectedProducts()).toBe(false)
        spy.reset()
        spy.andReturn(1)
        expect(scope.hasSelectedProducts()).toBe(true)

      it 'should be able to tell how many pieces of a product can bought', ()->
        products.stockOf = jasmine.createSpy();
        amount = 15
        products.stockOf.andReturn(amount);
        product = {}
        expect(scope.maxBuyable(product)).toBe amount
        expect(products.stockOf).toHaveBeenCalledWith product
      
      it 'should be able to find a buyer by username', ()->
        user = {username: 'name'}
        spy= users.findByUsername = jasmine.createSpy()
        spy.andReturn(user)
        scope.setBuyerByName(user.username)
        expect(users.findByUsername).toHaveBeenCalledWith(user.username)
        expect(basket.buyer).toBe(user)
        
      it 'should be able to tell if a buyer is selected', ()->
        expect(scope.validBuyer()).toBe(false)
        basket.buyer = {id:1, username:'lala'}
        expect(scope.validBuyer()).toBe(true)
      
      it 'should be able to remove a buyer selection', ()->
        basket.setBuyer = jasmine.createSpy()
        scope.clearBuyer()
        expect(basket.setBuyer).toHaveBeenCalledWith()
      
      it 'should be able to show the basket'      
      it 'should be able to be bought'
      it 'should be able to clear the basket (remove the buyer & products)'
      it 'should be able to close the modal window without any changes'

  describe 'Basket', ->
    basket = undefined
    products = undefined
    buys = {}
    beforeEach ->
      module 'Kassa.Buys', ($provide)-> 
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
      expect(angular.isDefined(basket.chosenProducts)).toBe true
  
   
      
    describe 'adding products and removing products', ->
      product=undefined
      beforeEach ()->
        product = Factory.build('product')
      it 'can add products', ->
        basket.add product
        expect(basket.products()[product.id].product).toEqual product
    
      it 'adding already existing products again increments their amount', -> 
        basket.add product for num in [0..1]
        expect(basket.countOf(product)).toEqual 2

      it 'can remove products', ->
        basket.add product
        basket.remove product
        expect(basket.hasProduct(product)).toBe false
      
      it 'removes only a single product, aka decrements the product amount', ->
        basket.add product for num in [0..2]
        basket.remove product
        expect(basket.countOf(product)).toBe 2

      it 'removes all entries of a single product on removeAll(product)', ->
        basket.add product for num in [0..2]
        basket.removeAll product
        expect(basket.hasProduct(product)).toBe false
      
      it 'removes all products on removeAll()', ->
        basket.add product
        basket.add Factory.build 'product'
        basket.removeAll()
        expect(basket.hasProducts()).toBe false

      it 'removes all products on clear',->
        basket.add product
        basket.clear()
        expect(basket.hasProducts()).toBe false
      
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
        basket.setBuyer(Factory.build('user'))
        expect(basket.hasBuyer()).toBe true
      
      it 'should be able to tell if a specific user is the buyer', ->
        user = {}
        basket.buyer = user
        expect(basket.isBuyer(user)).toBe true
           
    describe 'valid basket', ->
      product = undefined
      beforeEach ->
        product = Factory.build 'product'

      it 'all products should have amounts >= 1', ->
        basket.add product
        expect(basket.hasValidProducts()).toBe true
        basket.chosenProducts[product.id].amount = 0
        expect(basket.hasValidProducts()).toBe false
      
      it 'user should be selected', ->
        expect(basket.hasValidBuyer()).toBe false
        basket.buyer = Factory.build 'user'
        expect(basket.hasValidBuyer()).toBe true
      
      it 'all products should have amounts <= their stock', ->
        basket.add product
        expect(basket.hasValidProducts()).toBe true
        products.stockOf.andReturn(0)
        expect(basket.hasValidProducts()).toBe false
    

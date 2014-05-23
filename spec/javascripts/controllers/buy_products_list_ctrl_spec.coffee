describe 'BuyProductsListCtrl', ->
  #These need to match exactly the states in BuyProductsListCtrl
  [STATE_DEFAULT, STATE_SUCCESS, STATE_ERROR] = [3,2,1]

  [scope, Product, Basket] = [null, null, null]

  [products, buy] = [[], {}]

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    Product = all: jasmine.createSpy('Product.all').andReturn($q.when(products))
    Basket =
      buy: jasmine.createSpy('Basket.buy').andReturn($q.when(buy)),
      isBuyable: jasmine.createSpy('Basket.isBuyable').andReturn(true)
    $controller('BuyProductsListCtrl', $scope: scope, ProductService: Product, BasketService: Basket)

  describe 'initialization', ->
    it "should assign Basket to scope", ->
      expect(scope.basket).toBe(Basket)

    it "should set the scope.state to STATE_DEFAULT", ->
      expect(scope.state).toEqual(STATE_DEFAULT)

    it "should assign STATE_DEFAULT to scope.DEFAULT", ->
      expect(scope.DEFAULT).toEqual(STATE_DEFAULT)

    it "should assign STATE_ERROR to scope.ERROR", ->
      expect(scope.ERROR).toEqual(STATE_ERROR)

    it "should load all products", ->
      scope.$apply()
      expect(Product.all).toHaveBeenCalled()
      expect(scope.products).toBe(products)

  describe 'scope.buy', ->
    it "should not perform the buy if Basket is buyable", ->
      scope.buy()
      expect(Basket.isBuyable).toHaveBeenCalled()
      expect(Basket.buy).toHaveBeenCalled()

    it "should not perform the buy if Basket is not buyable", ->
      Basket.isBuyable.andReturn(false)
      scope.buy()
      expect(Basket.isBuyable).toHaveBeenCalled()
      expect(Basket.buy).not.toHaveBeenCalled()

    it "should set the scope.state to STATE_SUCCESS on success", ->
      scope.buy()
      scope.$apply()
      expect(scope.state).toEqual(STATE_SUCCESS)

    it "should set the scope.state to STATE_ERROR on failure", inject ($q)->
      Basket.buy.andReturn($q.reject({}))
      scope.buy()
      scope.$apply()
      expect(scope.state).toEqual(STATE_ERROR)

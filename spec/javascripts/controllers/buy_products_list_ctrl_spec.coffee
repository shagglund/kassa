describe 'BuyProductsListCtrl', ->
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

    it "should set the scope.state to a StateHandler", ->
      expect(scope.state.constructor.name).toEqual('StateHandler')

    it "should load all products", ->
      scope.$apply()
      expect(Product.all).toHaveBeenCalled()
      expect(scope.products).toBe(products)

  describe 'scope.buy', ->
    doBuy = (apply=false)->
      scope.buy()
      scope.$apply() if apply

    it "should not perform the buy if Basket is buyable", ->
      doBuy()
      expect(Basket.isBuyable).toHaveBeenCalled()
      expect(Basket.buy).toHaveBeenCalled()

    it "should not perform the buy if Basket is not buyable", ->
      Basket.isBuyable.andReturn(false)
      doBuy()
      expect(Basket.isBuyable).toHaveBeenCalled()
      expect(Basket.buy).not.toHaveBeenCalled()

    it "should set the scope.state to success on success", ->
      doBuy(true)
      expect(scope.state.isSuccess()).toBe(true)

    it "should set the scope.state to error on failure", inject ($q)->
      Basket.buy.andReturn($q.reject({}))
      doBuy(true)
      expect(scope.state.isError()).toBe(true)

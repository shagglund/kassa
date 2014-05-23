describe 'BuyToBasketCtrl', ->
  [scope, Basket] = [null, null]

  createFakeBuy = (availabilityValues...)->
    buy = consistsOfProducts: (product: {available: a} for a in availabilityValues)

  beforeEach module 'kassa'
  beforeEach inject ($controller, $rootScope)->
    scope = $rootScope.$new()
    Basket = {setFromBuy: jasmine.createSpy('Basket.setFromBuy')}
    $controller('BuyToBasketCtrl', $scope: scope, BasketService: Basket)

  describe 'scope.setToBasket', ->
    it 'should be bound Basket.setFromBuy', ->
      expect(scope.setToBasket).toBe(Basket.setFromBuy)

  describe 'scope.allProductsAvailable', ->
    it "should return true if all products from a buy are still available", ->
      buy = createFakeBuy(true, true, true)
      expect(scope.allProductsAvailable(buy)).toBe(true)

    it "should return false if all products from a buy are not still available", ->
      buy = createFakeBuy(true, true, false)
      expect(scope.allProductsAvailable(buy)).toBe(false)
describe 'ProductDetailCtrl', ->
  [scope, Product] = [null, null]
  equal = angular.equals

  #these need to match exactly the ones in ProductDetailCtrl
  [STATE_FAILED, STATE_SAVED, STATE_SAVING, STATE_DEFAULT] = [0,1,2,3]

  product = price: 1.10
  updatedProduct = price: 2.20

  priceEuro = (product)-> Math.floor(product.price)
  priceCent = (product)-> (product.price % 1) * 100

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    Product = {currentByRoute: jasmine.createSpy('Product.currentByRoute').andReturn($q.when(product))}
    $controller('ProductDetailCtrl', $scope: scope, ProductService: Product)

  describe 'initialization', ->
    it "should assign STATE_SAVED to scope.SAVED", ->
      expect(scope.SAVED).toEqual(STATE_SAVED)

    it "should assign STATE_FAILED to scope.FAILED", ->
      expect(scope.FAILED).toEqual(STATE_FAILED)

    it "should assign STATE_SAVING to scope.SAVING", ->
      expect(scope.SAVING).toEqual(STATE_SAVING)

    it "should assign STATE_DEFAULT to scope.DEFAULT", ->
      expect(scope.DEFAULT).toEqual(STATE_DEFAULT)

    it "should load the current product", ->
      scope.$apply()
      expect(Product.currentByRoute).toHaveBeenCalled()
      expect(equal(scope.product, product)).toBe(true)
      expect(scope.priceEuro).toEqual(priceEuro(product))
      expect(scope.priceCent).toEqual(priceCent(product))

  describe 'scope.changed', ->
    beforeEach -> scope.$apply()

    it "should return true if the product has been changed", ->
      scope.product.price += 1
      expect(scope.changed(scope.product)).toBe(true)

    it "should return false if the product has not been changed", ->
      expect(scope.changed(scope.product)).toBe(false)

  describe 'scope.cancel', ->
    beforeEach -> scope.$apply()

    it "should set scope.priceEuro to the initial products price euros", ->
      scope.priceEuro += 1
      expect(scope.priceEuro).toNotEqual(priceEuro(product))
      scope.cancel()
      expect(scope.priceEuro).toEqual(priceEuro(product))

    it "should set scope.priceCent to the initial products price cents", ->
      scope.priceCent += 10
      expect(scope.priceCent).toNotEqual(priceCent(product))
      scope.cancel()
      expect(scope.priceCent).toEqual(priceCent(product))

    it "should set scope.product data to the initial product data", ->
      scope.product.price += 1
      expect(equal(scope.product, product)).toBe(false)
      scope.cancel()
      expect(equal(scope.product, product)).toBe(true)

  describe 'scope.save', ->
    beforeEach inject ($q)->
      Product.update = jasmine.createSpy('Product.update').andReturn($q.when(updatedProduct))
      scope.$apply()

    it "should update the product using ProductService", ->
      testProduct = scope.product
      scope.save(scope.product)
      scope.$apply()
      expect(Product.update).toHaveBeenCalledWith(testProduct)

    it "should set the updated product to scope on success", ->
      expect(scope.product.price).toNotEqual(updatedProduct.price)
      scope.save(scope.product)
      scope.$apply()
      expect(equal(scope.product, updatedProduct)).toBe(true)
      expect(scope.priceEuro).toEqual(priceEuro(updatedProduct))
      expect(scope.priceCent).toEqual(priceCent(updatedProduct))

    it "should reset changes on success", ->
      scope.product.price += 1
      expect(scope.changed(scope.product)).toBe(true)
      scope.save(scope.product)
      scope.$apply()
      expect(scope.changed(scope.product)).toBe(false)

    it "should set scope.state to STATE_SAVING on call", ->
      scope.save(scope.product)
      expect(scope.state).toEqual(STATE_SAVING)

    it "should set scope.state to STATE_SAVED on success", ->
      scope.save(scope.product)
      scope.$apply()
      expect(scope.state).toEqual(STATE_SAVED)

    it "should set scope.state to STATE_FAILED on error", inject ($q)->
      Product.update.andReturn($q.reject({}))
      scope.save(scope.product)
      scope.$apply()
      expect(scope.state).toEqual(STATE_FAILED)


  describe 'scope.updatePrice', ->
    beforeEach -> scope.$apply()

    it "should set the product price", ->
      expect(scope.product.price).toNotEqual(11.12)
      scope.updatePrice(scope.product, 11, 12)
      expect(scope.product.price).toEqual(11.12)


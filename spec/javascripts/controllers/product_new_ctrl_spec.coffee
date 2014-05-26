describe 'ProductNewCtrl', ->
  [scope, location, Product] = [null, null, null]
  isObject = angular.isObject

  #states need to match the ones in ProductNewCtrl
  [STATE_FAILED, STATE_SAVING, STATE_DEFAULT] = [0, 1, 2]

  product = {id: 1}

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    location = {path: jasmine.createSpy('$location.path')}
    Product = {create: jasmine.createSpy('Product.create').andReturn($q.when(product))}
    $controller('ProductNewCtrl', $scope: scope, $location: location, ProductService: Product)

  describe 'initialization', ->
    it "should assign a new product to scope", ->
      expect(isObject(scope.product)).toBe(true)
      expect(scope.product.available).toBe(true)

    it "should assign STATE_FAILED to scope.FAILED", ->
      expect(scope.FAILED).toEqual(STATE_FAILED)

    it "should assign STATE_SAVING to scope.SAVING", ->
      expect(scope.SAVING).toEqual(STATE_SAVING)

    it "should assign STATE_DEFAULT to scope.DEFAULT", ->
      expect(scope.DEFAULT).toEqual(STATE_DEFAULT)

    it "should set the scope.state to STATE_DEFAULT", ->
      expect(scope.state).toEqual(STATE_DEFAULT)

  describe 'scope.cancel', ->
    beforeEach inject ($compile)->
      #create and compile an actual form to assign newProductForm as a FormController on scope
      element = '<form name="newProductForm"></form>'
      $compile(element)(scope);

    it "should set a new product to scope", ->
      oldProduct = scope.product
      scope.cancel()
      expect(isObject(scope.product)).toBe(true)
      expect(scope.product.available).toBe(true)
      expect(scope.product).toNotBe(oldProduct)

    it "should set the product form as pristine", ->
      spyOn(scope.newProductForm, '$setPristine').andCallThrough()
      scope.cancel()
      expect(scope.newProductForm.$setPristine).toHaveBeenCalled()

  describe 'scope.setPrice', ->
    it "should set the product.price based on euros and cents", ->
      scope.setPrice(product, 2, 15)
      expect(product.price).toEqual(2.15)

  describe 'scope.save', ->
    saveProduct = (apply=false)->
      scope.save(scope.product)
      scope.$apply() if apply
    it "should create the product", ->
      saveProduct()
      expect(Product.create).toHaveBeenCalledWith(scope.product)

    it "should set scope.state to STATE_SAVING", ->
      saveProduct()
      expect(scope.state).toEqual(STATE_SAVING)

    it "should redirect to the product details on success", ->
      saveProduct(true)
      expect(location.path).toHaveBeenCalledWith("/products/#{product.id}")

    it "should set scope.state to STATE_FAILED on failure", inject ($q)->
      Product.create.andReturn($q.reject({}))
      saveProduct(true)
      expect(scope.state).toEqual(STATE_FAILED)

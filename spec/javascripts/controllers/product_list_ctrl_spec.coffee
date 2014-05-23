describe 'ProductListCtrl', ->
  [scope, Product] = [null, null]

  products = []

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    Product = {all: jasmine.createSpy('Product.all').andReturn($q.when(products))}
    $controller('ProductListCtrl', $scope: scope, ProductService: Product)

  describe 'initialization', ->
    it "should load all products", ->
      scope.$apply()
      expect(Product.all).toHaveBeenCalled()
      expect(scope.products).toBe(products)

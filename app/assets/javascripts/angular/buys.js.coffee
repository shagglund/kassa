angular.
module('kassa.buys', ['kassa.common','kassa.products', 'kassa.materials', 'kassa.users', 'ui.bootstrap.modal']).
service('Buys', (BaseService, Materials, Users)->
  options = {}
  actions =
    index:
      method: 'GET'
    create:
      method: 'POST'
  class Buys extends BaseService
    constructor: (@materialService, @userService)->
      super '/buys', options, actions
      
    latest: ()=>
      col = @entries()
      col.sort (first, second)->
        Date.parse(second.created_at) - Date.parse(first.created_at)
      col[0..9]

    _handleRawResponse: (action, response, responseHeaders)=>
      if action is 'create'
        @materialService.updateChanged response.materials
        @userService.updateChanged response.buyer
      return

    _encode: (buy)->
      buyer_id: buy.id, products_attributes: @_encodeEntries(buy.products)

    _encodeEntries: (entries)->
      collected= @_encodeEntry entry for entry in entries

    _encodeEntry: (entry)->
      product_id: entry.product.id, amount: entry.amount

  new Buys(Materials, Users)
).service('Basket', (Buys, Products)->
  class Basket
    constructor: (@buyService, @productService)->
      @_products = []
    
    entries: ->
      @_products

    setBuyer: (buyer)=>
      if @buyer != buyer
        @buyer = buyer
      else
        @clearBuyer()
    
    getEntry: (product)->
      return entry for entry in @_products when entry.product == product

    add: (product, amount=1) =>
      return unless amount > 0
      if @hasProduct product
        @_changeAmount product, amount
      else
        @_addNewProduct product, amount

    remove: (product, amount=1)=>
      return unless amount > 0
      if @countOf(product) <= 1
        @_remove product
      else
        @_changeAmount product, -amount

    removeAll: (product)=>
      if angular.isDefined product
        @_remove product
      else
        @_products.length = 0
    
    countOf: (product)=>
      p = @getEntry product
      if p then p.amount else 0

    productCount: =>
      count = 0
      for entry in @_products
        do (entry) ->
          count += entry.amount
      count

    clear: =>
      @removeAll()
      @clearBuyer()

    clearBuyer: =>
      @buyer = undefined

    hasBuyer: ()=>
      angular.isDefined(@buyer)

    isBuyer: (user)=>
      @buyer == user

    price: =>
      price = 0.00
      for entry in @_products
        do (entry)->
          price += @productService.priceOf(entry.product) * entry.amount
      price
    
    hasValidBuyer: =>
      @hasBuyer()

    hasValidProducts: =>
      return false for entry in @_products when !@_canBeBought(entry)
      @hasProducts()

    hasProducts: =>
      @_products.length > 0
    
    hasProduct: (product) =>
      return true for entry in @_products when entry.product == product
      return false

    valid: =>
      @hasValidProducts() and @hasValidBuyer()

    buy: () =>
      if @valid()
        @buyService.create(@)
      else
        false

    _canBeBought: (entry)=>
      return @_enoughInStock(entry.product, entry.amount) and entry.amount > 0
    
    _remove: (product)=>
      @_products.splice i for entry, i in @_products when entry.product == product
      
    _addNewProduct:(product, amount=1)=>
      @_products.push product: product, amount: amount
  
    _changeAmount: (product, amount)=>
      entry = @getEntry product
      return unless entry
      if amount > 0 and @_enoughInStock product, entry.amount+amount
        entry.amount+=amount
      else if amount < 0 and entry.amount + amount > 1
        entry.amount += amount
      else
        entry.amount = 1

    _enoughInStock: (product, amount)->
      @productService.stockOf(product) >= amount

  new Basket(Buys, Products)

).controller('BuysController', ($scope, Buys)->
  $scope.buys = Buys

).controller('BasketController', ($scope, Basket, Users, Products)->
  $scope.basket = Basket

  $scope.maxBuyable= (product)->
    Products.stockOf(product)

  $scope.isEmpty = (obj)->
    angular.isUndefined(obj) or obj.length == 0

  $scope.setBuyerByName= (username)->
    Basket.buyer = Users.findByUsername username

  $scope.openBasket= ->
    $scope.basketShouldBeOpen = true

  $scope.buyAndCloseBasket= ($event)=>
    _stopEvent($event)
    Basket.buy().then ()->
      Basket.clear()
      $scope.closeBasket()

  $scope.clearAndCloseBasket=($event)=>
    Basket.clear()
    $scope.closeBasket($event)

  $scope.closeBasket=($event)=>
    $scope.basketShouldBeOpen = false
    _stopEvent($event)

  _stopEvent=($event)->
    $event.stopPropagation()
    $event.preventDefault()
).controller('BuysProductsController', ($scope, Basket, Products)->
  $scope.basket = Basket
  $scope.products = Products
  
  $scope.entries = ->
    (p for p in Products.entries() when Products.stockOf(p) > 0)

  $scope.init = ->
    unless Products.entries().length
      Products.index()

).controller('BuysUsersController', ($scope, Basket, Users)->
  $scope.basket = Basket
  $scope.users = Users
)

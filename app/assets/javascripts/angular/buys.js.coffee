angular.module('kassa.buys', ['kassa.common','kassa.products', 'kassa.materials', 'kassa.users', 'ui.bootstrap.modal']).
service('Buys', (BaseService, Materials, Users)->
  class Buys extends BaseService
    constructor: (@materialService, @userService)->
      options = {}
      actions =
        index:
          method: 'GET'
        create:
          method: 'POST'
      super '/buys', options, actions
      
    latest: ->
      col = @entries()
      col.sort (first, second)->
        Date.parse(second.created_at) - Date.parse(first.created_at)
      col[0..9]

    _handleRawResponse: (action, response, responseHeaders)->
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

    products: ->
      @_products

    setBuyer: (buyer)->
      @buyer = buyer
    
    getEntry: (product)->
      return entry for entry in @_products when entry.product == product

    add: (product, amount=1) ->
      return unless amount > 0
      if @hasProduct product
        @_changeAmount product, amount
      else
        @_addNewProduct product, amount

    remove: (product, amount=1)->
      return unless amount > 0
      if @countOf(product) <= 1
        @_remove product
      else
        @_changeAmount product, -amount

    removeAll: (product)->
      if angular.isDefined product
        @_remove product
      else
        @_products.length = 0
    
    countOf: (product)->
      p = @getEntry product
      if p then p.amount else 0

    productCount: ->
      count = 0
      for entry in @_products
        do (entry) ->
          count += entry.amount
      count

    clear: ->
      @removeAll()
      @clearBuyer()

    clearBuyer: ->
      @buyer = undefined

    hasBuyer: ->
      angular.isDefined(@buyer)

    isBuyer: (user)->
      @buyer == user

    totalPrice: ->
      price = 0.00
      price += @priceOf(entry) for entry in @products()
      price

    priceOf: (entry)->
      entry.amount * @productService.priceOf(entry.product)
      
    hasValidBuyer: ->
      @hasBuyer()

    hasValidProducts: ->
      return false for entry in @_products when !@_canBeBought(entry)
      @hasProducts()

    hasProducts: ->
      @_products.length > 0
    
    hasProduct: (product) ->
      return true for entry in @_products when entry.product == product
      return false

    isValid: ->
      @hasValidProducts() and @hasValidBuyer()

    buy: () ->
      if @isValid()
        @buyService.create(@)
      else
        false

    isMaxBuyable: (entry)->
      @productService.stockOf(entry.product) is entry.amount

    isMinBuyable: (entry)->
      entry.amount is 1

    _canBeBought: (entry)->
      return @_enoughInStock(entry.product, entry.amount) and entry.amount > 0
    
    _remove: (product)->
      @_products.splice(i,1) for entry, i in @_products when entry.product == product
      
    _addNewProduct:(product, amount=1)->
      @_products.push product: product, amount: amount
  
    _changeAmount: (product, amount)->
      entry = @getEntry product
      return unless entry
      if amount > 0 and @_enoughInStock product, entry.amount+amount
        entry.amount+=amount
      else if amount < 0 and entry.amount + amount >= 1
        entry.amount += amount

    _enoughInStock: (product, amount)->
      @productService.stockOf(product) >= amount

  new Basket(Buys, Products)

).service('BasketModal', (Basket)->
  class BasketModal
    constructor: ->
      @_isOpen = false
  
    open: ->
      @_isOpen = true
    
    close: ->
      @_isOpen = false

    isOpen: ->
      @_isOpen

  new BasketModal()
).controller('BuysController', ($scope, Buys)->
  $scope.buys = Buys
  
  $scope.init = ->
    unless Buys.entries().length > 0
      Buys.index()

).controller('BasketController', ($scope, Basket, Users, Products, BasketModal)->
  errors = {}
  $scope.basket = Basket
  $scope.modal = BasketModal

  $scope.maxBuyable= (product)->
    Products.stockOf(product)

  $scope.isEmpty = (obj)->
    angular.isUndefined(obj) or obj.length == 0

  $scope.setBuyerByName= (username)->
    Basket.buyer = Users.findByUsername username
  
  $scope.buy= ->
    success = ->
      Basket.clear()
      BasketModal.close()
    failure=  (errorResponse)->
      errors = errorResponse.data
    Basket.buy().then success, failure

  $scope.clear=->
    Basket.clear()
    BasketModal.close()

  $scope.buyerBalanceAfterBuy = ->
    Basket.buyer.balance - Basket.totalPrice()

).controller('BuysProductsController', ($scope, Basket, Products, BasketModal)->
  filtered = []
  DEFAULTS=
    filterQuery: []
    filterField: 'name'
  $scope.basket = Basket
  $scope.products = Products
  $scope.filterField = DEFAULTS.filterField
  $scope.filterQuery = DEFAULTS.filterQuery
  $scope.modal = BasketModal
  
  $scope.entries = ->
    $scope.refilter() unless filtered.length > 0
    filtered
  
  $scope.refilter = ->
    filtered.length = 0
    buyable = (p for p in Products.entries() when Products.stockOf(p) > 0)
    filtered = $scope.filter(buyable, $scope.filterQuery, $scope.filterField)

  $scope.clearFilter = ->
    $scope.filterField = DEFAULTS.filterField
    $scope.filterQuery = DEFAULTS.filterQuery
    $scope.refilter()

  $scope.init = ->
    unless Products.entries().length
      Products.index()

).controller('BuysUsersController', ($scope, Basket, Users, BasketModal)->
  filtered = []
  DEFAULTS=
    filterQuery: []
    filterField: 'username'
  $scope.basket = Basket
  $scope.users = Users
  $scope.filterField = DEFAULTS.filterField
  $scope.filterQuery = DEFAULTS.filterQuery
  $scope.modal = BasketModal
    
  $scope.entries = ->
    $scope.refilter() unless filtered.length > 0
    filtered
  
  $scope.refilter = ->
    filtered.length = 0
    filtered = $scope.filter(Users.entries(), $scope.filterQuery, $scope.filterField)

  $scope.clearFilter = ->
    $scope.filterField = DEFAULTS.filterField
    $scope.filterQuery = DEFAULTS.filterQuery
    $scope.refilter()

  $scope.init = ->
    unless Users.entries().length > 0
      Users.index()

  $scope.iconByBalance = (balance)->
    if balance > 50
      'icon-briefcase'
    else if balance > 0
      'icon-star'
    else if balance > -25
      'icon-thumbs-down'
    else if balance > -50
      'icon-warning-sign'
    else if balance > -100
      'icon-fire'
    else
      'icon-ban-circle'
)

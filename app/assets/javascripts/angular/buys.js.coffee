angular.
module('kassa.buys', ['kassa.abstract', 'kassa.products', 'kassa.users', 'ui.bootstrap.modal']).
service('Buys', ($resource, Products, Users)->
  class Buys
    constructor: ($resource)->
      options = {}
      actions =
        index:
          method: 'GET'
        create:
          method: 'POST'
      @resource = $resource '/buys', options, actions
      @collection = []
      @index()

    index: (opts={}, success, failure)=>
      middle = (response)=>
        @collection.length = 0
        @collection.push buy for buy in response.collection
        opts.success @collection if angular.isFunction opts.success
        return
      @resource.index(opts.options, middle, opts.failure)

    create: (opts={})=>
      return unless opts.buy
      middle = (response)=>
        Products.updateChangedMaterials response.materials
        Users.updateChangedUser response.object.buyer
        opts.success response.object if angular.isFunction opts.success
        return

      apiBuy = @_encode opts.buy
      @resource.create(apiBuy, middle, opts.failure)

    latest: ()=>
      @collection.sort (first, second)->
        Date.parse(second.created_at) - Date.parse(first.created_at)
      @collection[0..9]

    _encode: (buy)->
      buyer_id: buy.id, products_attributes: @_encodeEntries(buy.products)

    _encodeEntries: (entries)->
      collected= @_encodeEntry entry for entry in entries

    _encodeEntry: (entry)->
      product_id: entry.product.id, amount: entry.amount

  new Buys()
).service('Basket', (Buys, Products)->
  class Basket
    constructor: ->
      @_products = []
    
    entries: ->
      entry for entry in @_products

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
          price += Products.priceOf(entry.product) * entry.amount
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

    buy: (success,failure) =>
      if @valid()
        Buys.create(@, success, failure)
      else
        failure('Invalid basket')
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
      Products.stockOf(product) >= amount

  new Basket()

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
    Basket.buy((closeBasket)->
    )

  $scope.clearAndCloseBasket=($event)=>
    Basket.clear()
    $scope.closeBasket($event)

  $scope.closeBasket=($event)=>
    $scope.basketShouldBeOpen = false
    _stopEvent($event)

  _stopEvent=($event)->
    $event.stopPropagation()
    $event.preventDefault()
)

angular.module('kassa').factory('BasketService', [
  '$http'
  '$location'
  '$rootScope'
  'UserService'
  'ProductService'
  'BuyService'
  ($http, $location, $rootScope, User, Product, Buy)->
    [isObject, isUndefined] = [angular.isObject, angular.isUndefined]
    products = []
    buyer = null

    _productMatch = (product, entry)-> entry.product.id == product.id

    addProduct = (product)->
      if _.findIndex(products, _.partial(_productMatch, product)) != -1
        false
      else
        products.push {product, amount: 1}
        true

    removeProduct = (product)->
      index = _.findIndex(products, _.partial(_productMatch, product))
      if index == -1
        false
      else
        products.splice(index, 1)
        true

    setProducts = (newProducts)-> products = newProducts

    hasProducts = -> products.length > 0

    hasProduct = (product)-> _.findIndex(products, _.partial(_productMatch, product)) != -1

    changeAmount = (product, amount)->
      entry = _.find(products, _.partial(_productMatch, product))
      unless entry.amount + amount < 1
        entry.amount += amount

    _entryAmountReducer = (sum, entry)-> sum + entry.amount
    productCount = (product)->
      if isUndefined(product)
        _.reduce products, _entryAmountReducer, 0
      else
        entry = _.find(products, _.partial(_productMatch, product))
        entry?.amount || 0

    _entryPrice = (entry)-> (entry.amount * entry.product.price)
    _entryPriceReducer = (sum, entry)-> sum + _entryPrice(entry)
    price = (entry)->
      if isUndefined(entry)
        _.reduce(products, _entryPriceReducer, 0.0)
      else
        _entryPrice(entry)

    setBuyer = (user)-> buyer = user
    removeBuyer = -> setBuyer(null)

    isBuyable = -> hasProducts() && buyer

    setFromBuy = (buy, navigateToBuyPage=true)->
      copyEntries = (buyEntry)-> {product: buyEntry.product, amount: buyEntry.amount}

      setBuyer(buy.buyer)
      newProducts = _.map(buy.consistsOfProducts, copyEntries)
      setProducts(newProducts)

      $location.path('/buy') if navigateToBuyPage

    emptyBasketAndRemoveBuyer = ->
      removeBuyer()
      setProducts([])

    buy = ->
      Buy.create(buyer, products).then (resp)->
        emptyBasketAndRemoveBuyer(false)
        resp

    #return api-object with methods/objects accessible from outside
    {
      addProduct
      removeProduct
      hasProducts
      hasProduct
      products: -> products
      changeAmount
      productCount
      price
      setBuyer
      removeBuyer
      hasBuyer: -> isObject(buyer)
      buyer: -> buyer
      isBuyable
      setFromBuy
      empty: emptyBasketAndRemoveBuyer
      buy
    }
])
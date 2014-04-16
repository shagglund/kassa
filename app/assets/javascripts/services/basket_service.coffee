angular.module('kassa').service('BasketService', [
  '$http'
  '$location'
  '$rootScope'
  'UserService'
  'ProductService'
  ($http, $location, $rootScope, User, Product)->
    products = []
    buyer = null

    changeAmount = (entry, amount)->
      name = entry.product.name
      currentAmount = parseInt($location.search()[name])
      unless currentAmount + amount < 1
        newAmount = currentAmount + amount
        $location.search(name, newAmount).replace()

    emptyBasketAndRemoveBuyer = (showBasket=true)->
      searchObj = $location.search()
      delete searchObj.buyer

      delete searchObj[entry.product.name] for entry in products
      products.splice(0, products.length)

      searchObj.basket = showBasket
      $location.search(searchObj).replace()

    entryAmountReducer = (sum, entry)-> sum+entry.amount
    productCount = -> products.reduce entryAmountReducer, 0

    entryPrice = (entry)-> (entry.amount * entry.product.price)
    entryPriceReducer = (sum, entry)-> sum + entryPrice(entry)
    price = (entry)->
      if entry?
        entryPrice(entry)
      else
        products.reduce(entryPriceReducer, 0.0)

    isBuyable = -> hasProducts() && buyer

    hasProducts = -> products.length > 0

    setFromBuy = (buy)->
      search = $location.search()
      if $location.path() == '/buy'
        emptyBasketAndRemoveBuyer()
        search.replace()
      else
        search.path('/buy')

      search.buyer = buy.buyer.username
      search.basket = "true"

      for entry in buy.consistsOfProducts
        search[entry.product.name] = entry.amount

      $location.search(search)

    ##### Update basket state based on route changes #####

    INTEGER_REGEXP = /^\d+$/m
    resolveProducts = ->
      productMapper = (newProducts, amount, name)->
        amount = _.parseInt(amount)
        entry = _.find(products, (e)-> e.product.name == name)
        if entry?
          entry.amount = amount
        else
          #fake the id with name as both should be unique
          entry = {product: {name: name, id: name}, amount}
          Product.find(name).then (product)-> entry.product = product
        newProducts.push entry

      products = _.chain($location.search())
        .pick (value)-> INTEGER_REGEXP.test(value)
        .transform(productMapper, [])
        .value()

    resolveBuyer = ->
      username = $location.search().buyer
      if buyer?.username == username
        buyer
      else if username?
        buyer = User.find(username).then (user)-> buyer = user
      else
        buyer = undefined

    updateStateFromSearch = ->
      resolveProducts()
      resolveBuyer()

    $rootScope.$on '$routeUpdate', updateStateFromSearch
    updateStateFromSearch()

    #return api-object with methods/objects accessible from outside
    {
      changeAmount
      productCount
      price
      isBuyable
      hasProducts
      setFromBuy
      empty: emptyBasketAndRemoveBuyer
      products: -> products
      buyer: -> buyer
    }
])
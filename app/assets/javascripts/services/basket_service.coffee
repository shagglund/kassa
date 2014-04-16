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

    entryByProductName = (entries, name)->
      return entry for entry in entries when entry.product.name == name
      null

    INTEGER_REGEXP = /^\d+$/m
    validateAndParseInteger = (value)->
      parseInt(value) if INTEGER_REGEXP.test(value)

    createEntryAndFindProduct = (name, amount)->
      entry = {product: {name: name, id: name}, amount}
      Product.find(name).then (product)-> entry.product = product
      entry

    resolveProducts = ->
      oldProducts = products
      products = []
      for own name, amount of $location.search()
        continue unless (amount = validateAndParseInteger(amount))?
        #update amount or add a new product if non-existent
        entry = entryByProductName(oldProducts, name)
        if entry?
          entry.amount = amount
        else
          entry = createEntryAndFindProduct(name, amount)
        products.push entry
      products

    resolveBuyer = ->
      username = $location.search().buyer
      if buyer?.username == username
        buyer
      else if username?
        #always return the current promise if resolving to prevent multiple requests being run for the same resource
        return buyer if buyer?.then?
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
angular.module('kassa').service('BasketService', [
  '$http'
  '$location'
  '$rootScope'
  'UserService'
  'ProductService'
  ($http, $location, $rootScope, User, Product)->
    products = []
    buyer = null

    INTEGER_REGEXP = /^\d+$/m
    isProductSearchValue = (value)-> INTEGER_REGEXP.test(value)
    isNotProductSearchValue = (value)-> !isProductSearchValue(value)
    isBuyerSearchValue = (value, key)-> key == 'buyer'
    isNotBuyerSearchValue = (value, key)-> !isBuyerSearchValue

    changeAmount = (entry, amount)->
      name = entry.product.name
      currentAmount = _.parseInt($location.search()[name])
      unless currentAmount + amount < 1
        newAmount = currentAmount + amount
        $location.search(name, newAmount).replace()

    emptyBasketAndRemoveBuyer = (showBasket=true)->
      searchObj = _.chain($location.search())
        .pick isNotProductSearchValue
        .pick isNotBuyerSearchValue
        .assign basket: (if showBasket then "true" else "false")
        .value()
      $location.search(searchObj).replace()

    entryAmountReducer = (sum, entry)-> sum + entry.amount
    productCount = -> _.reduce products, entryAmountReducer, 0

    entryPrice = (entry)-> (entry.amount * entry.product.price)
    entryPriceReducer = (sum, entry)-> sum + entryPrice(entry)
    price = (entry)->
      if entry?
        entryPrice(entry)
      else
        _.reduce(products, entryPriceReducer, 0.0)

    isBuyable = -> hasProducts() && buyer

    hasProducts = -> products.length > 0

    setFromBuy = (buy)->
      entryToProductNameHash = (result, entry)->
        result[entry.product.name] = entry.amount

      search = _.chain($location.search())
        .assign buyer: buy.buyer.username, basket: true
        .assign _.reduce(buy.consistsOfProducts, entryToProductNameHash, {})
        .value()

      if $location.path() == '/buy'
        $location.search(search).replace()
      else
        $location.search(search).path('/buy')

    ##### Update basket state based on route changes #####
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
        .pick(isProductSearchValue)
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
    $rootScope.$on '$routeChangeSuccess', updateStateFromSearch
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
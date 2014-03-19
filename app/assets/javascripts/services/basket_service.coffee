angular.module('kassa').service('BasketService', [
  '$http'
  '$location'
  'UserService'
  'ProductService'
  ($http, $location, User, Product)->
    products = []
    buyer = null

    changeAmount = (entry, amount)->
      name = entry.product.name
      currentAmount = parseInt($location.search()[name])
      unless currentAmount + amount < 1
        newAmount = currentAmount + amount
        $location.search(name, newAmount).replace()

    empty = ->
      searchObj = $location.search()
      delete searchObj.buyer
      delete searchObj[entry.product.name] for entry in products

      products.splice(0, products.length)
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

    isBuyable = -> products.length > 0 && exports.buyer

    entryByProductName = (entries, name)->
      return entry for entry in entries when entry.product.name == name
      null

    delayedAddProduct = (name, amount)->
      entry = {product: {name: name, id: name}, amount}
      products.push entry
      (product)-> entry.product = product

    resolveProducts = ->
      oldProducts = products
      products = []
      for own k, v of $location.search()
        v = parseInt(v)
        continue if isNaN(v)

        #update amount or add a new product if non-existent
        entry = entryByProductName(oldProducts, k)
        if entry?
          entry.amount = v
          products.push entry
        else
          Product.find(k).then delayedAddProduct(k, v)

      products

    resolveBuyer = ->
      username = $location.search().buyer
      if buyer?.username == username
        buyer
      else if username?
        #always return the current promise if resolving to prevent multiple requests being run for the same resource
        return buyer if buyer?.then?
        buyer = User.find(username).then (user)-> buyer = user

    setFromBuy = (buy)->
      empty()
      search = $location.search()
      search.buyer = buy.buyer.username
      for entry in buy.consistsOfProducts
        search[entry.product.name] = entry.amount
      $location.search(search).replace()

    #return api-object with methods/objects accessible from outside
    exports = {
      changeAmount: changeAmount
      empty: empty
      productCount: productCount
      price: price
      isBuyable: isBuyable
      products: resolveProducts
      buyer: resolveBuyer
      setFromBuy: setFromBuy
    }
])
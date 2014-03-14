angular.module('kassa').service('BasketService', [
  '$http'
  '$location'
  'UserService'
  ($http, $location, User)->
    products = []
    buyer = null

    changeAmount = (entry, amount)->
      if entry.amount + amount < 1
        entry.amount = 1
      else if entry.amount + amount > entry.product.stock
        entry.amount = entry.product.stock
      else
        entry.amount += amount

    remove = (entry)->
      products.splice(products.indexOf(entry), 1)

    empty = ->
      products.splice(0, products.length)
      buyer = undefined

    entryAmountReducer = (sum, entry)-> sum+entry.amount
    productCount = -> products.reduce entryAmountReducer, 0

    entryPrice = (entry)-> (entry.amount * entry.product.price).toFixed(2)
    entryPriceReducer = (sum, entry)-> sum + entryPrice(entry)

    price = (entry)->
      if entry?
        entryPrice(entry)
      else
        products.reduce(entryPriceReducer, 0.0)

    isBuyable = -> products.length > 0 && exports.buyer

    resolveProducts = ->
      products
    resolveBuyer = ->
      username = $location.search().buyer
      if buyer?.username == username
        buyer
      else if username?
        #always return the current promise if resolving to prevent multiple requests being run for the same resource
        return buyer if buyer?.then?
        buyer = User.find(username).then (user)-> buyer = user
    #return api-object with methods/objects accessible from outside
    exports = {
      changeAmount: changeAmount
      remove: remove
      empty: empty
      productCount: productCount
      price: price
      isBuyable: isBuyable
      products: resolveProducts
      buyer: resolveBuyer
    }
])
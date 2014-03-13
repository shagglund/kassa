angular.module('kassa').service('BasketService', [
  '$http'
  ($http)->
    products = []

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
      delete exports.buyer

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

    #return api-object with methods/objects accessible from outside
    exports = {
      products: products
      changeAmount: changeAmount
      remove: remove
      empty: empty
      productCount: productCount
      price: price
      isBuyable: isBuyable
    }
])
angular.module('kassa.products', ['kassa.abstract', 'kassa.buys'])
.service('Products', ->
  class Products
    constructor: ->

    priceOf: (product)=>
      price = 0.00
      for entry in product.materials
        do (entry)->
          price += entry.material.price * entry.amount
      price.toFixed 2

    stockOf: (product)=>
      stock = -1
      for entry in product.materials
        do (entry)->
          amount = Math.floor entry.amount / entry.material.stock
          stock = amount if stock == -1 or stock > amount
      stock

  new Products()
).controller('ProductsBuyController', ($scope, Products, Basket)->

)

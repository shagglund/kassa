angular.module('kassa.products', ['kassa.common', 'kassa.materials'])
.service('Products', (BaseService, Materials)->
  options = {id: '@id'}
  actions =
    index:
      method: 'GET'
    create:
      method: 'POST'
    update:
      method: 'PUT'
    destroy:
      method: 'DELETE'
  class Products extends BaseService
    constructor: (@materialService)->
      super '/products/:id', options, actions

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
          amount = Math.floor entry.material.stock / entry.amount
          stock = amount if stock == -1 or stock > amount
      stock

    _add: (products...)=>
      for product in products
        do (product)=>
          entry.material = @materialService.findById entry.material for entry in product.materials
          @collection.push product
      return products

    _encode: (product)=>
      product #TODO minimize and encode for rails
    
  new Products(Materials)
).controller('ProductsController', ($scope, Products, Basket)->

)

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

    first: =>
      @collection[0]

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

    _handleRawResponse: (action, response, responseHeaders)=>
      if action is 'index'
        @materialService.updateChanged response.materials...
    _addSingle: (product)=>
      for entry in product.materials
        do (entry)=>
          unless angular.isObject entry.material
            entry.material = @materialService.findById entry.material
      super product

    _encode: (product)=>
      prod =
        id: product.id
        product:
          description: product.description
          name: product.name
          unit: product.unit
          group: product.group
          materials_attributes: @_encodeMaterials product.materials

    _encodeMaterials: (entries)=>
      {amount: entry.amount, material: entry.material.id} for entry in entries

  new Products(Materials)
).controller('ProductsController', ($scope, Products)->
  $scope.products = Products

  $scope.entries = ()->
    Products.entries()

  $scope.init = ()->
    unless Products.entries().length > 0
      Products.index()
    
  $scope.selectFirst = ->
    $scope.currentProduct = Products.first()

  $scope.select = (product)->
    $scope.currentProduct = product

  $scope.isSelected = (product)=>
    $scope.currentProduct == product
)

angular.module('kassa.products', ['kassa.common', 'kassa.materials'])
.service('Products', (BaseService, Materials)->
  class ProductService extends BaseService
    constructor: (@materialService)->
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
      super '/products/:id', options, actions

    first: ->
      @collection[0]

    priceOf: (product)->
      price = 0.00
      for entry in product.materials
        do (entry)->
          price += entry.material.price * entry.amount
      price.toFixed 2

    stockOf: (product)->
      stock = -1
      for entry in product.materials
        do (entry)->
          amount = Math.floor entry.material.stock / entry.amount
          stock = amount if stock == -1 or stock > amount
      stock

    _handleRawResponse: (action, response, responseHeaders)->
      if action is 'index'
        @materialService.updateChanged response.materials...

    _addSingle: (product)->
      for entry in product.materials
        do (entry)=>
          if angular.isNumber entry.material
            entry.material = @materialService.findById entry.material
      super product

    _encode: (product)->
      prod =
        id: product.id
        product:
          id: product.id
          description: product.description
          name: product.name
          unit: product.unit
          group: product.group
          consists_of_materials_attributes: @_encodeMaterials product.materials

    _encodeMaterials: (entries)->
      {amount: entry.amount, material: entry.material.id} for entry in entries

  new ProductService(Materials)
).controller('ProductsController', ($scope, Products)->
  $scope.products = Products

  $scope.entries = ()->
    Products.entries()

  $scope.init = ()->
    unless Products.entries().length > 0
      Products.index()
    
  $scope.newProduct= ->
    $scope.currentProduct = $scope.newProduct ={}

  $scope.select = (product)->
    $scope.currentProduct = angular.copy(product)

  $scope.isSelected = (product)->
    $scope.currentProduct == product

  $scope.isBeer= (product)->
    product.group == 'beer'
)

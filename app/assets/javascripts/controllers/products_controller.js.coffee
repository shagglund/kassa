class Kassa.ProductsController extends Batman.Controller

  index: ->
    unless @get('products')
      Kassa.Product.load (error, products) =>
        throw error if error
        @set('products', products)

  new: ->
    @set('currentProduct', new Kassa.Product)

  create: ->
    @get('currentProduct').save (error)=>
      throw error unless error instanceof Batman.ErrorsSet or error == undefined


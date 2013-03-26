class Basket
  constructor: (@dataService)->
    @products=[]

  setBuyer: (buyer)->
    @buyer = buyer
  
  add: (product) ->
    if angular.isUndefined @_entryByProduct(product)
      @products.push {amount: 1, product: product}

  changeAmount: (product, amount=1)->
    entry = @_entryByProduct product
    if angular.isDefined entry
      entry.amount += amount

  remove: (product)->
    @products.splice(i,1) for e, i in @products when e.product.id == product.id

  productCount: (product)->
    if angular.isDefined product
      entry = @_entryByProduct product
      entry.amount if angular.isDefined entry
    else
      _.inject @products, (sum, entry)->
        sum+= entry.amount

  clear: ->
    @products.length = 0 #lazy remove by just setting the arrays length to 0
    @clearBuyer()

  clearBuyer: ->
    @buyer = undefined

  hasBuyer: ->
    angular.isDefined(@buyer)

  isBuyer: (user)->
    @buyer == user

  totalPrice: ->
    summer = (sum, entry)->
      sum += entry.amount * entry.product.price()
    _.inject @products, summer, 0.0

  hasProducts: ->
    @products.length > 0
  
  hasProduct: (product) ->
    angular.isDefined @_entryByProduct(product)

  isValid: ->
    @hasProducts() and @hasBuyer()

  buy: ->
    @_buy = @dataService.new 'buy'
    @_buy.buyer @buyer
    @_buy.add e.product, e.amount for e in @products
    @_buy.save()

  _entryByProduct: (product)->
    _.find @products, (entry)=>
      entry.product.attributes.id == product.attributes.id

angular.module('kassa.services.basket', ['kassa.services.data'])
.service('Basket', (DataService)->
  new Basket(DataService)
)

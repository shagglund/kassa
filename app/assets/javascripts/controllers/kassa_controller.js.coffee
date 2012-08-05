class Kassa.KassaController extends Kassa.ApplicationController
  routingKey: 'kassa'
  # Add actions to this controller by defining functions on it.
  #
  # show: (params) ->

  index: ->
    Kassa.Product.load (error, products) =>
      throw error if error
      @set 'products', products

    Kassa.User.load (error, users) =>
      throw error if error
      @set 'users', users

    @set('buy', new Kassa.Buy)

    # Add functions to run before an action with
    #
    # @beforeFilter 'someFunctionKey'  # or
    # @beforeFilter -> ...
    #

  selectBuyer: (node, event) =>
    Kassa.User.find $(node).children().eq(0).text(), (error, user) =>
      throw error if error
      @set('buy.buyer', user)
      console?.log "Buyer is now #{@get('buy.buyer.username')}"

  clearBuyer: (node, event) =>
    @unset 'buy.buyer'

  addProductToBasket: (node, event) =>
    product = Product.find $(node).children().eq(0).text(), (error, product) =>
      throw error if error
      entry = new Kassa.BuyEntry({amount:1, buy: @get('buy'), product: product})
      @get('buy.entries').add(entry)
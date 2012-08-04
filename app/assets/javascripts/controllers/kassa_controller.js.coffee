class Kaljakassa.KassaController extends Kaljakassa.ApplicationController
  routingKey: 'kassa'
  # Add actions to this controller by defining functions on it.
  #
  # show: (params) ->

  index: ->
    Kaljakassa.Basket.findOrCreate 1, (error, basket) =>
      @set('basket', basket)

    # Add functions to run before an action with
    #
    # @beforeFilter 'someFunctionKey'  # or
    # @beforeFilter -> ...
    #
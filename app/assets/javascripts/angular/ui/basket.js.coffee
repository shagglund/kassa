angular.module('kassa.ui.dialogs.basket', ['ui.bootstrap.dialog'])
.service('BasketDialog', ($dialog)->
  new BasketDialog($dialog)
)

class BasketDialog
  constructor: (@dialogService)->
    @_isOpen = false
    @_opts=
      keyboard: true
      backdrop: true
      backdropClick: true
      templateUrl: '/partials/basket'
      controller: 'BasketController'

  open: ->
    @_dialog = @dialogService.dialog(@_opts) if angular.isUndefined @_dialog
    @_dialog.open()
    @_isOpen = true
  
  close: ->
    @_isOpen = false
    @_dialog.close()

  isOpen: ->
    @_isOpen



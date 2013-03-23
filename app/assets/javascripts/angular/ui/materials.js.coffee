angular.module('kassa.ui.dialogs.material', ['ui.bootstrap.dialog'])
.service('MaterialDialog', ($dialog)->
  new MaterialDialog($dialog)
)

class MaterialDialog
  constructor: (@dialogService)->
    @_isOpen = false
    @_opts =
      keyboard: true
      backdrop: true
      backdropClick: true
      templateUrl: '/partials/modal_material_form'
      controller: 'MaterialsController'

  isOpen: =>
    @_isOpen

  open: =>
    @_dialog = @dialogService.dialog(@_opts) if angular.isUndefined(@_dialog)
    @_dialog.open()
    @_isOpen = true

  close: =>
    @_dialog.close()
    @_isOpen = false
    @selected = undefined

  openWith: (material)=>
    @selected = material
    @open()

  cancelChangesAndClose: =>
    @selected.cancelChanges()
    @close()



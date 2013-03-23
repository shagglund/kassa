dependencies=[
  'kassa.services.data'
  'kassa.ui.dialogs.material'
]
angular.module('kassa.controllers.materials', dependencies)
.controller('MaterialsController', ($scope, DataService, MaterialDialog)->
  $scope.dialog = MaterialDialog
  $scope.currentMaterial = MaterialDialog.selected

  $scope.cancelAndClose= ->
    $scope.currentMaterial.cancelChanges()
    MaterialDialog.close()
)

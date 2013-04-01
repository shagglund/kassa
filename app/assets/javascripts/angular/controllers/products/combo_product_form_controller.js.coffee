dependencies= [
  'kassa.services.data'
]
cpfController =  ($scope, DataService)->


angular.module('kassa.controllers.products.combo_form', dependencies)
.controller('ComboProductFormController', ['$scope', 'DataService', cpfController])

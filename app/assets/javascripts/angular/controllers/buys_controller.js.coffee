dependencies=[
  'kassa.services.data'
]
angular.module('kassa.controllers.buys', dependencies)
.controller('BuysController', ($scope, DataService)->
  $scope.latest= ->
    DataService.collection('buys')

)

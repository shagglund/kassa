dependencies=[
  'kassa.services.data'
]
angular.module('kassa.controllers.buys', dependencies)
.controller('BuysController', ($scope, DataService)->
  $scope.buys = ->
    DataService.collection('buys')

  $scope.latest= ->
    $scope.buys().reverse()

)

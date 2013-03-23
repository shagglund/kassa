dependencies=[
  'kassa.services.data'
]
angular.module('kassa.controllers.buys', dependencies)
.controller('BuysController', ($scope, DataService)->
  $scope.entries= ->
    DataService.collection 'buys'

)

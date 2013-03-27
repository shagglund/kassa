dependencies=[
  'kassa.services.data'
]
angular.module('kassa.controllers.buys.latest', dependencies)
.controller('LatestBuysController', ($scope, DataService)->
  $scope.latest= ->
    DataService.collection('buys')

)

dependencies=[
  'kassa.services.data'
]
buysController =($scope, DataService)->
  $scope.latest= ->
    DataService.collection('buys')

angular.module('kassa.controllers.buys.latest', dependencies)
.controller('LatestBuysController', ['$scope', 'DataService', buysController])

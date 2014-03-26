angular.module('kassa').directive('kassaStateChecker',[
  '$location'
  ($location)->
    linker = ($scope, $element, $attrs)->
      getCurrentState = (key)-> $location.search()[key]
      isSelectedState = (key, value)->  getCurrentState(key) == value

      $scope.isSelectedState = isSelectedState
      $scope.getCurrentState = getCurrentState

    restrict: 'A', scope: false, link: linker
])
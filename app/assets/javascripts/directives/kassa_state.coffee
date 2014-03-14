angular.module('kassa').directive('kassaState',[
  '$location'
  ($location)->
    linker = ($scope, $element, $attrs)->
      stateKey = $attrs.kassaState
      stateValue = $attrs.kassaStateValue

      getCurrentState = (key)-> $location.search()[key]
      isSelectedState = (key, value)->  getCurrentState(key) == value

      $element.on 'click', ->
        $scope.$apply ->
          $location.search(stateKey, stateValue).replace()

      $scope.isSelectedState = isSelectedState
      $scope.getCurrentState = getCurrentState

    restrict: 'A', scope: false, link: linker
])
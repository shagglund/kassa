angular.module('kassa').directive('kassaSetState',[
  '$location'
  ($location)->
    linker = ($scope, $element, $attrs)->
      stateKey = $attrs.kassaSetState
      stateValue = $attrs.kassaValue

      $element.on 'click', ->
        $scope.$apply ->
          $location.search(stateKey, stateValue).replace()

    restrict: 'A', scope: false, link: linker
])
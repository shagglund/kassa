angular.module('kassa').directive('kassaStateRemove',[
  '$location'
  ($location)->
    linker = ($scope, $element, $attrs)->
      stateKey = $attrs.kassaStateRemove

      $element.on 'click', ->
        $scope.$apply ->
          $location.search(stateKey, null).replace()

    restrict: 'A', scope: false, link: linker
])
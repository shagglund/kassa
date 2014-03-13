angular.module('kassa').directive('kassaStateToggle',[
  '$location'
  ($location)->
    linker = ($scope, $element, $attrs)->
      stateKey = $attrs.kassaStateToggle
      defaultValue = $attrs.kassaStateDefault || false

      unless $location.search()[stateKey]?
       $location.search stateKey, defaultValue

      isInVisibleState = (key)->
        stateValue = $location.search()[key]
        stateValue == "true"

      $element.on 'click', ->
        $scope.$apply ->
          value = String(!isInVisibleState(stateKey))
          $location.search(stateKey, value).replace()

      $scope.isInVisibleState = isInVisibleState

    restrict: 'A', scope: false, link: linker
])
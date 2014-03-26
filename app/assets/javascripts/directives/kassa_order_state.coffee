angular.module('kassa').directive('kassaOrderState',[
  '$location'
  ($location)->
    linker = ($scope, $element, $attrs)->
      stateKey = $attrs.kassaOrderState
      stateValue = $attrs.kassaValue

      isOrderedBy = (stateValueToMatch)->
        $location.search()[stateKey]?.split(':')[0] == stateValueToMatch

      isDescending = ->
        $location.search()[stateKey]?.split(':')[1] == 'true'

      $element.on 'click', ->
        $scope.$apply ->
          if isOrderedBy(stateValue)
            order = !isDescending()
          else
            order = false
          $location.search(stateKey, "#{stateValue}:#{order}").replace()

    restrict: 'A', scope: false, link: linker
])
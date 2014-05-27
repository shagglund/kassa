angular.module('kassa')
.filter('orderByState', [
  '$location'
  'orderByFilter'
  ($location, orderBy)->
    (array, stateKey)->
      return array unless array?.length > 0
      stateValue = $location.search()[stateKey]?.split(':')
      stateField = stateValue?[0]
      order = stateValue?[1] == 'true'
      orderBy(array, stateField, order)
])
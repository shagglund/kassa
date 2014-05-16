angular.module('kassa').filter('fuzzyMatch', ->
  [isString, isArray] = [angular.isString, angular.isArray]
  (array, needles, field)->
    return array unless isArray(array)
    return array unless isArray(needles) && needles.length > 0
    _.filter array, (elem)->
      return false unless isString(elem[field])
      elementContainsNeedle = (value, needle)-> value.indexOf(needle) != -1
      _.some(needles, _.partial(elementContainsNeedle, elem[field].toLowerCase()))
)
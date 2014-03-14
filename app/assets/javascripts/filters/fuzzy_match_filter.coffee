angular.module('kassa').filter('fuzzyMatch', ->
  (array, needles, field)->
    return array unless array?
    return array unless needles?.length > 0
    array.filter (elem)->
      return true for needle in needles when elem[field].indexOf(needle) != -1
      false
)
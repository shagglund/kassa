angular.module('kassa').filter('fuzzyMatch', ->
  (array, needles, field)->
    return array unless array?
    return array unless needles?.length > 0
    _.filter array, (elem)-> _.findIndex(needles, (needle)-> elem[field].indexOf(needle) != -1) != -1
)
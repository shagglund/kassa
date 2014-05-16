angular.module('kassa')
.filter('active', ->
  (array)->
    return array unless array?.length > 0
    _.filter(array, 'active')
)
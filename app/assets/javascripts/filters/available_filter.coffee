angular.module('kassa')
.filter('available', ->
  (array)->
    return array unless array?.length > 0
    array.filter((obj)-> obj.available)
)
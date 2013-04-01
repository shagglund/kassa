rootScopeSetup = ($rootScope)->
  fieldValue = (item, fields)->
    r = item
    r = item[f] for f in fields when angular.isDefined r
    r
  matches = (item, queryList, fields)->
    return true if queryList.length is 0
    regExpList = (new RegExp(query, 'i') for query in queryList)
    value = fieldValue item, fields
    return true for regexp in regExpList when regexp.test value
    false

  $rootScope.filter = (items, queryList, fieldString)->
    fields = fieldString.split '.'
    (item for item in items when matches(item, queryList, fields))

  $rootScope.gravatarUrl = (email,size=16)->
    Gravtastic(email, {default: 'mm', size: size})
  
  return

angular.module('kassa.common', [])
.run(['$rootScope', rootScopeSetup])

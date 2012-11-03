module = angular.module('Kassa', ['Kassa.routes'])

module.run(['$rootScope', ($rootScope)->
  sortedAscendingByField = (array, field)->
    f = s = array[0]
    for i in [1..array.length-1]
      f = s
      s = array[i]
      return false if f[field] > s[field]
    return true

  $rootScope.I18n = I18n
  $rootScope.sort = (array, field)->
    return if array.length is 1
    if sortedAscendingByField(array, field)
      array.reverse()
    else
      array.sort (first, second)->
        if first[field] == second[field]
          0
        else
          if first[field] < second[field] then -1 else 1

  $rootScope.incrementByOne = (object, field) ->
    object[field] += 1

  $rootScope.decrementByOne = (object, field, positive=true)->
    object[field] -= 1 unless object[field] <= 1 and positive
])
module.run(['$http', ($http)->
  if token = $("meta[name='csrf-token']").attr("content")
    $http.defaults.headers.post['X-CSRF-Token'] = token
    $http.defaults.headers.put['X-CSRF-Token'] = token
    $http.defaults.headers.delete = {'X-CSRF-Token':token}
    return
])
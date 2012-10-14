angular.module('Kassa', ['Kassa.routes']).run(['$http', ($http)->
  if token = $("meta[name='csrf-token']").attr("content")
    $http.defaults.headers.post['X-CSRF-Token'] = token
    $http.defaults.headers.put['X-CSRF-Token'] = token
    $http.defaults.headers.delete = {'X-CSRF-Token':token}
    return
])
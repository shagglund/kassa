dependencies=[
  'kassa.controllers'
  'kassa.services'
  'kassa.directives'
  'kassa.filters'
  'kassa.routes'
  'kassa.common'
  'kassa.session'
]
angular.module('kassa', dependencies)
  .run( ($http)->
    token = $("meta[name='csrf-token']").attr("content")
    if angular.isDefined token
      $http.defaults.headers.post['X-CSRF-Token'] = token
      $http.defaults.headers.put['X-CSRF-Token'] = token
      $http.defaults.headers.delete = {'X-CSRF-Token': token}

  )

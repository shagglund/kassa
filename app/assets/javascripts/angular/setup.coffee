angular.module(
  'Kassa', ['Kassa.services', 'Kassa.controllers', 'Kassa.common']
).config(($routeProvider) ->
  $routeProvider.when('/buys', { templateUrl: '/partials/buys.html', controller: 'BuysController'})
  $routeProvider.when('/products', { templateUrl: '/partials/products.html', controller: 'ProductsController'})
  $routeProvider.when('/users', { templateUrl: '/partials/users.html', controller: 'UsersController'})

  $routeProvider.otherwise {redirectTo: '/'}
).run(['$http', ($http)->
  if token = $("meta[name='csrf-token']").attr("content")
    $http.defaults.headers.post['X-CSRF-Token'] = token
    $http.defaults.headers.put['X-CSRF-Token'] = token
    $http.defaults.headers.delete = {'X-CSRF-Token':token}
    return
])
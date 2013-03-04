angular.module('kassa', ['kassa.buys', 'kassa.products', 'kassa.users', 'kassa.session', 'kassa.navigation'])
  .config(($routeProvider)->
    $routeProvider.when '/buys',
      templateUrl: '/partials/buys.html',
      controller: 'BuysController'
    $routeProvider.when '/products',
      templateUrl: '/partials/products.html',
      controller: 'ProductsController'
    $routeProvider.when '/users',
      templateUrl: '/partials/users.html',
      controller: 'UsersController'
    $routeProvider.when '/login',
      templateUrl: '/partials/login.html',
      controller: 'SessionController'
    $routeProvider.otherwise
      redirectTo: '/login'
  ).run( ($http)->
    token = $("meta[name='csrf-token']").attr("content")
    if angular.isDefined token
      $http.defaults.headers.post['X-CSRF-Token'] = token
      $http.defaults.headers.put['X-CSRF-Token'] = token
      $http.defaults.headers.delete = {'X-CSRF-Token': token}

  )

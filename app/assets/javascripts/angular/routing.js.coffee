angular.module('kassa.routes', [])
.config(($routeProvider)->
  $routeProvider.when '/buys',
    templateUrl: '/partials/buys.html',
    controller: 'BuysController'
  $routeProvider.when '/products',
    templateUrl: '/partials/products.html',
    controller: 'ProductsController'
  $routeProvider.when '/products/:id',
    templateUrl: '/partials/products.html',
    controller: 'ProductsController'
  $routeProvider.when '/users',
    templateUrl: '/partials/users.html',
    controller: 'UsersController'
  $routeProvider.when '/users/:id',
    templateUrl: '/partials/users.html',
    controller: 'UsersController'
  $routeProvider.when '/login',
    templateUrl: '/partials/login.html',
    controller: 'SessionController'
  $routeProvider.otherwise
    redirectTo: '/login'
)

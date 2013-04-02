angular.module('kassa.routes', [])
.config(['$routeProvider', ($routeProvider)->
  $routeProvider.when '/',
    redirectTo: '/buys'
  $routeProvider.when '',
    redirectTo: '/buys',
  $routeProvider.when '/buys',
    templateUrl: '/partials/buys.html'
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
  $routeProvider.otherwise
    templateUrl: '/partials/not_found.html'
])

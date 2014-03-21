#= require angular-route
#= require angular-locale-fi.min
#= require_self
#= require_tree ./services
#= require_tree ./controllers
#= require_tree ./directives
#= require_tree ./filters

angular.module('kassa', ['ngRoute', 'kassa.templates'])
.config([
  '$locationProvider'
  ($locationProvider)->
    $locationProvider.html5Mode(true).hashPrefix('!')
])
.config([
  '$httpProvider'
  ($httpProvider)->
    $httpProvider.defaults.headers.common.Accept = 'application/json'

    #Set the CSRF protection token from the meta tag in html
    for tag in document.getElementsByTagName('meta')
      if tag.name == 'csrf-token'
        $httpProvider.defaults.headers.common['X-CSRF-Token'] = tag.content
])
.config([
  '$routeProvider'
  ($routeProvider)->
    $routeProvider
      .when('', redirectTo: '/buy')
      .when('/', redirectTo: '/buy')
      .when('/buy', templateUrl: '/tpl/buy.html', reloadOnSearch: false)
      .when('/products', templateUrl: '/tpl/products.html', reloadOnSearch: false)
      .when('/products/:id', templateUrl: '/tpl/product_details.html', reloadOnSearch: false)
      .when('/users', templateUrl: '/tpl/users.html', reloadOnSearch: false)
      .when('/users/:id', templateUrl: '/tpl/user_details.html', reloadOnSearch: false)
      .when('/404', templateUrl: '/tpl/404.html')
      .otherwise(redirectTo: '/404')

])
.run([
  '$rootScope'
  'SessionService'
  ($rootScope, Session)->
    #Make session available to every inherited controller
    $rootScope.session = Session
])
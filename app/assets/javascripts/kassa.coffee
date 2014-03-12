#= require angular-route
#= require_self
#= require_tree ./services
#= require_tree ./controllers
#= require_tree ./directives

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
      .when('/404', templateUrl: '/tpl/404.html')
      .otherwise(redirectTo: '/404')

])
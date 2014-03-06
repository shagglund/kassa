#= require angular-route
#= require_self
#= require_tree ./services
#= require_tree ./controllers

angular.module('kassa', ['ngRoute'])
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
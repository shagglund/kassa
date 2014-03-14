angular.module('kassa').service('UserService',[
  '$http'
  '$routeParams'
  ($http, $routeParams)->
    index = -> $http.get('/users')
    get = (id)-> $http.get("/users/#{id}")

    all = -> index().then (resp)-> resp.data.users
    find = (id)-> get(id).then (resp)-> resp.data.user
    currentByRoute = -> find($routeParams.id)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
    }
])
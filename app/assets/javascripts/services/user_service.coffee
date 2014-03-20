angular.module('kassa').service('UserService',[
  '$http'
  '$routeParams'
  ($http, $routeParams)->
    convertUser = (user)->
      user.balance = parseFloat(user.balance)
    convert = (resp)->
      users = resp.data.users
      if users?
        convertUser(user) for user in users
      else
        convertUser(resp.data.user)
      resp

    getFromResponse = (resp)-> resp.data.user || resp.data.users

    all = -> $http.get("/users").then(convert).then(getFromResponse)

    find = (id)-> $http.get("/users/#{id}").then(convert).then(getFromResponse)

    currentByRoute = -> find($routeParams.id)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
    }
])
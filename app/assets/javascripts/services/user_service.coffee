angular.module('kassa').service('UserService',[
  '$http'
  '$routeParams'
  '$rootScope'
  ($http, $routeParams, $rootScope)->
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

    broadcastNewUser = (user)->
      $rootScope.$broadcast 'user:new', user
      user

    all = -> $http.get("/users").then(convert).then(getFromResponse)

    find = (id)-> $http.get("/users/#{id}").then(convert).then(getFromResponse)

    currentByRoute = -> find($routeParams.id)

    update = (user)->
      $http.put("/users/#{user.id}", {user}).then(convert).then(getFromResponse)

    updateBalance = (user, newBalance, changeNote)->
      data = balance: newBalance, description: changeNote
      $http.put("/users/#{user.id}/update_balance", user: data).then(convert).then(getFromResponse)

    create = (user)->
      $http.post("/users", {user}).then(convert).then(getFromResponse).then(broadcastNewUser)

    #exposed methods
    {all, find, currentByRoute, update, updateBalance, create}
])
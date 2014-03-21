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

    update = (user)->
      $http.put("/users/#{user.id}", {user}).then(convert).then(getFromResponse)

    updateBalance = (user, newBalance, changeNote)->
      data = balance: newBalance, description: changeNote
      $http.put("/users/#{user.id}/update_balance", data).then(convert).then(getFromResponse)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
      update: update
      updateBalance: updateBalance
    }
])
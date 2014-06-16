angular.module('kassa').factory('UserService',[
  '$http'
  '$routeParams'
  '$rootScope'
  'CacheService'
  '$q'
  ($http, $routeParams, $rootScope, Cache, $q)->
    [isObject, isNumber, copy] = [angular.isObject, angular.isNumber, angular.copy]

    CACHE_PREFIX = 'user'

    convertUser = (user)->
      user.balance = parseFloat(user.balance)

    cacheUser = (user)-> Cache.set(user, CACHE_PREFIX)

    convert = (resp)->
      users = resp.data.users
      if users?
        _.forEach users, convertUser
      else
        convertUser(resp.data.user)
      resp

    getFromResponse = (resp)-> resp.data.user || resp.data.users

    broadcastNewUser = (user)->
      $rootScope.$broadcast 'user:new', user
      user

    _broadcastBalanceChange = (user)->
      $rootScope.$broadcast 'user:balanceChange', user
      user

    all = ->
      $http.get("/users").then(convert).then(getFromResponse).then (users)->
        _.forEach users, cacheUser
        #rewrite all loader function to use the now populated cache
        exports.all = all = -> Cache.getAllByPrefix(CACHE_PREFIX)
        all()

    find = (id)->
      Cache.getByIdentity(id, CACHE_PREFIX).then (user)->
        return user if isObject(user) && isNumber(user.id)
        $http.get("/users/#{id}").then(convert).then(getFromResponse).then(cacheUser)

    currentByRoute = -> find($routeParams.id)

    update = (user)->
      $http.put("/users/#{user.id}", {user}).then(convert).then(getFromResponse).then(cacheUser)

    updateBalance = (user, newBalance, changeNote)->
      data = balance: newBalance, description: changeNote
      $http.put("/users/#{user.id}/update_balance", user: data).then(convert).then(getFromResponse).then(cacheUser).then(_broadcastBalanceChange)

    create = (user)->
      $http.post("/users", {user}).then(convert).then(getFromResponse).then(cacheUser).then(broadcastNewUser)


    $rootScope.$on 'buys:new', (event, buy)->
      Cache.getByIdentity(buy.buyerId, CACHE_PREFIX).then (user)->
        if isObject(user)
          buy.buyer = copy(buy.buyer, user)
        else
          convertUser(buy.buyer)
          cacheUser(buy.buyer)

    #exposed methods
    exports = {all, find, currentByRoute, update, updateBalance, create}
])
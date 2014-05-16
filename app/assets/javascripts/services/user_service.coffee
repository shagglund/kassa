angular.module('kassa').service('UserService',[
  '$http'
  '$routeParams'
  '$rootScope'
  'CacheService'
  ($http, $routeParams, $rootScope, Cache)->
    [isObject, isNumber, copy] = [angular.isObject, angular.isNumber, angular.copy]

    CACHE_PREFIX = 'user'

    _convertAndCacheUser = (user)->
      user.balance = parseFloat(user.balance)
      Cache.set(user, CACHE_PREFIX)

    _convert = (resp)->
      users = resp.data.users
      if users?
        _.forEach users, _convertAndCacheUser
      else
        _convertAndCacheUser(resp.data.user)
      resp

    _getFromResponse = (resp)-> resp.data.user || resp.data.users

    _broadcastNewUser = (user)->
      $rootScope.$broadcast 'user:new', user
      user

    all = ->
      $http.get("/users").then(_convert).then(_getFromResponse).then (users)->
        #rewrite all loader function to use the now populated cache
        exports.all = all = -> Cache.getAllByPrefix(CACHE_PREFIX)
        users

    find = (id)->
      Cache.get(id, CACHE_PREFIX).then (user)->
        return user if isObject(user) && isNumber(user.id)
        $http.get("/users/#{id}").then(_convert).then(_getFromResponse)

    currentByRoute = -> find($routeParams.id)

    update = (user)->
      $http.put("/users/#{user.id}", {user}).then(_convert).then(_getFromResponse)

    updateBalance = (user, newBalance, changeNote)->
      data = balance: newBalance, description: changeNote
      $http.put("/users/#{user.id}/update_balance", user: data).then(_convert).then(_getFromResponse)

    create = (user)->
      $http.post("/users", {user}).then(_convert).then(_getFromResponse).then(_broadcastNewUser)


    $rootScope.$on 'buys:new', (event, buy)->
      Cache.get(buy.buyerId, CACHE_PREFIX).then (user)->
        if isObject(user)
          buy.buyer = copy(buy.buyer, user)
        else
          _convertAndCacheUser(buy.buyer)

    #exposed methods
    exports = {all, find, currentByRoute, update, updateBalance, create}
])
angular.module('kassa').factory('SessionService',[
  '$http'
  '$q'
  '$window'
  'UserService'
  'CacheService'
  ($http, $q, $window, User, Cache)->
    authenticatedUser = undefined
    equal = angular.equals

    loadCurrentUser = -> User.find('me').then((user)-> authenticatedUser = user)
    loadCurrentUser()

    signIn = (email, password, rememberMe=true)->
      $http.post('/user/sign_in', user: {email, password, rememberMe}).then(loadCurrentUser)

    signOut = ->
      $http.delete('/user/sign_out').then ->
        authenticatedUser = undefined
        #hacky way of redirecting since base-tag supported routing will hijack this via $location
        $window.location.assign('/user/sign_in')

    isCurrentUser = (user)-> equal(authenticatedUser, user)

    currentUser = (ensurePromise=true)->
      if ensurePromise then $q.when(authenticatedUser) else authenticatedUser

    isAdmin = -> !!authenticatedUser.admin

    {signIn, signOut, isCurrentUser, currentUser, isAdmin}
])
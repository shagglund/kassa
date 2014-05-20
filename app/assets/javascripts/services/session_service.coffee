angular.module('kassa').factory('SessionService',[
  '$http'
  '$q'
  '$window'
  'UserService'
  ($http, $q, $window, User)->
    authenticatedUser = null

    equal = angular.equals

    setUser = (user)-> authenticatedUser = user

    checkStatus = -> User.find('me').then(setUser)

    signIn = (email, password, rememberMe=true)->
      $http.post('/user/sign_in', user: {email, password, rememberMe}).then checkStatus()

    signOut = ->
      $http.delete('/user/sign_out').then ->
        authenticatedUser = null
        #hacky way of redirecting since base-tag supported routing will hijack this via $location
        $window.location.href = '/user/sign_in'

    isCurrentUser = (user)-> equal(authenticatedUser, user)

    currentUser = (ensurePromise=true)->
      if ensurePromise then $q.when(authenticatedUser) else authenticatedUser

    isAdmin = -> authenticatedUser.admin

    #load the current user if signed in and set to promise that will be resolved and watched automatically
    authenticatedUser = checkStatus()

    {checkStatus, signIn, signOut, isCurrentUser, currentUser, isAdmin}
])
angular.module('kassa').service('SessionService',[
  '$http'
  '$q'
  '$window'
  'UserService'
  ($http, $q, $window, User)->
    currentUser = null

    equal = angular.equals

    setUser = (user)-> currentUser = user

    checkStatus = -> User.find('me').then(setUser)

    signIn = (email, password, rememberMe=true)->
      $http.post('/user/sign_in', user: {email, password, rememberMe}).then checkStatus()

    signOut = ->
      $http.delete('/user/sign_out').then ->
        currentUser = null
        #hacky way of redirecting since base-tag supported routing will hijack this via $location
        $window.location.href = '/user/sign_in'

    #load the current user if signed in and set to promise that will be resolved and watched automatically
    currentUser = checkStatus()

    isCurrentUser = (user)-> equal(currentUser, user)

    {
      checkStatus: checkStatus
      signIn: signIn
      signOut: signOut
      currentUser: (ensurePromise=true)->
        if ensurePromise then $q.when(currentUser) else currentUser
      isCurrentUser: isCurrentUser
    }
])
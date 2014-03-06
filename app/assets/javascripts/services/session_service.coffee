angular.module('kassa').service('SessionService',[
  '$http'
  '$q'
  '$window'
  ($http, $q, $window)->
    currentUser = null

    setAuthenticated = (promise)-> promise.then (resp)-> currentUser = resp.data
    
    checkStatus = -> setAuthenticated $http.get('/users/me')
    signIn = (email, password, rememberMe=true)-> 
      setAuthenticated $http.post('/user/sign_in', user: {email, password, rememberMe})
    signOut = -> 
      setAuthenticated($http.delete('/user/sign_out')).then -> 
        #hacky way of redirecting since base-tag supported routing will hijack this via $location
        $window.location.href = '/user/sign_in'

    #load the current user if signed in and set to promise that will be resolved and watched automatically
    currentUser = checkStatus()

    {
      checkStatus: checkStatus
      signIn: signIn
      signOut: signOut
      currentUser: -> currentUser
    }
])
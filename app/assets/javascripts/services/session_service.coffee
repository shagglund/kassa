angular.module('kassa').service('SessionService',[
  '$http'
  '$q'
  ($http, $q)->
    currentUser = null

    setAuthenticated = (promise)-> promise.then (resp)-> currentUser = resp.data
    
    checkStatus = -> setAuthenticated $http.get('/users/me')
    signIn = (email, password)-> setAuthenticated $http.post('/sessions')
    signOut = -> setAuthenticated $http.delete('/sessions')

    #load the current user if signed in and set to promise that will be resolved and watched automatically
    currentUser = checkStatus()

    {
      checkStatus: checkStatus
      signIn: signIn
      signOut: signOut
      currentUser: -> currentUser
    }
])
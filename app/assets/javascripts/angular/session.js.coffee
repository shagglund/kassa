class Session
  constructor: (@$http, @$q, @$window)->
    @pendingUnauthorizedRequests = []
    @currentUser = undefined

  signIn: (credentials)=>
    success = (successResponse, status)=>
        @_setAuthenticated successResponse if status is 201
    deferred = @_defer @$http.post, '/user/sign_in', {user: credentials}
    deferred.then success, @_setUnauthenticated

  signOut: =>
    deferred = @_defer @$http.delete ,'/user/sign_out', {}
    deferred.then =>
      @$window.location.href = '/user/sign_in'

  checkStatus: =>
    deferred = @_defer @$http.get, '/users/current', {}
    deferred.then @_setAuthenticated, @_setUnauthenticated
    
  _runPendingRequests: ()=>
    for request in @pendingUnauthorizedRequests
      do (request)=>
        @$http(request.config).then (response)=>
          request.deferred.resolve(response)
    @pendingUnauthorizedRequests.length = 0
  
  _setAuthenticated: (response)=>
    @currentUser = response.user
    @_runPendingRequests()
    response

  _setUnauthenticated: (response)=>
    @currentUser = undefined
    response
  
  _defer: (httpFunc, url, options)=>
    deferred = @$q.defer()
    httpFunc(url, options).success(deferred.resolve).error(deferred.reject)
    deferred.promise
  
httpInterceptor = ($httpProvider)->
  handler = ($injector, $q)->
    success = (response)->
      response

    error = (response)->
      if response.status is 401
        #TODO handle unauthorized authentication as it could get stuck here if a 401 is returned
        deferred = $q.defer()
        req =
          config: response.config
          deferred: deferred
        #workaround for circular dependency as Session needs $http
        $injector.get('Session').pendingUnauthorizedRequests.push req
        deferred.promise
      $q.reject(response)

    (promise)->
      promise.then success, error

  interceptor = ['$injector','$q', handler]
  $httpProvider.responseInterceptors.push(interceptor)
  
angular.module('kassa.session', [])
.service('Session', ['$http','$q','$window',($http, $q, $window)->
  return new Session($http, $q, $window)
])
.config(['$httpProvider', httpInterceptor])


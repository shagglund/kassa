angular.module('kassa').factory('TestHelper',
  ($timeout)->
    flush = (cb)->
      $timeout(cb)
      $timeout.flush()
    {
      instantResolve: (deferred, value)-> flush(-> deferred.resolve(value))
      instantReject: (deferred, value)-> flush(-> deferred.reject(value))
    }
)
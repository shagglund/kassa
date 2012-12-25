angular.module('Kassa.Session', [])
  .service('Session', function($http, $window){
    var Session = {
      pendingUnauthorizedRequests: [],
      _runPendingRequests: function(){
        angular.forEach(this.pendingUnauthorizedRequests, function(request){
          $http(request.config).then(function(response){
            request.deferred.resolve(response)
          })
        });
        this.pendingUnauthorizedRequests.length = 0;
      },
      _setAuthenticated: function(user){
        this.signedIn = user;
        this._runPendingRequests();
      },
      signIn: function(email, password, authorized, unauthorized){
        $http.post($window.Kassa.prefixWithLocale('/users/sign_in'), {email: email, password: password})
          .success(function(successResponse, status){
            if(status == 201){
              Session._setAuthenticated(successResponse)
            }
            if(angular.isFunction(authorized)){
              authorized(successResponse, status)
            }
          }).error(function(failureResponse, status){
            Session._setAuthenticated();
            if(angular.isFunction(unauthorized)){
              unauthorized(failureResponse, status)
            }
          });
      },
      signOut: function(success, failure){
        $http.delete($window.Kassa.prefixWithLocale('/users/sign_out'), {})
          .success(function(successResponse, status){
            Session.signedIn = undefined;
            if(angular.isFunction(success)){
              success(successResponse, status)
            }
          }).error(function(failureResponse, status){
            if(angular.isFunction(failure)){
              failure(failureResponse, status)
            }
          });
      },
      checkStatus: function(authenticated, unauthenticated){
        $http.get($window.Kassa.prefixWithLocale('/users/current'), {})
          .success(function(user, status){
            Session._setAuthenticated(user);
            if(angular.isFunction(authenticated)){
              authenticated(user, status)
            }
          }).error(function(failure, status){
            if(angular.isFunction(unauthenticated)){
              unauthenticated(failure, status)
            }
          })
      }
    };
    return Session;
  })
  .controller('SessionController', function($scope, $location, Session){
    function navigateAuthenticated(){
      $location.path('/buys')
    }
    $scope.authenticated = function(){
      return angular.isDefined(Session.signedIn)
    };
    $scope.signIn = function(email, password){
      Session.signIn(email, password, function(){
        navigateAuthenticated();
        $scope.invalid = false
      }, function(){
        $scope.invalid = true;
      })
    };
    $scope.signOut = function(){
      $location.path('/')
    };
    Session.checkStatus(function(){
      navigateAuthenticated();
    })
  }).config(function($httpProvider){
    var interceptor = ['$injector','$q', function($injector, $q) {

      function success(response) {
        return response
      }

      function error(response) {
        if (response.status === 401) {
          var deferred = $q.defer();
          var req = {config: response.config, deferred: deferred};
          //workaround for circular dependency as Session needs $http
          $injector.get('Session').pendingUnauthorizedRequests.push(req);
          return deferred.promise;
        }
        // otherwise
        return $q.reject(response)
      }

      return function(promise) {
        return promise.then(success, error)
      }

    }];
    $httpProvider.responseInterceptors.push(interceptor);
  });
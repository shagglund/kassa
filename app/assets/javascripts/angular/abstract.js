angular.module('Kassa.Abstract',['ngResource'])
  .service('CollectionResource', function($resource, $window){
    function indexFunction(scopeObj){
      return function(options, success, failure){
        scopeObj.resource.index(options,
          function(successResponse, responseHeaders){
            scopeObj.collection = successResponse;
            if(angular.isFunction(success)){
              success(successResponse, responseHeaders);
            }
          }, function(failureResponse, responseHeaders){
            if(angular.isFunction(failure)){
              failure(failureResponse, responseHeaders);
            }
          });
      }
    }
    function createFunction(scopeObj){
      return function(object, success, failure){
        scopeObj.resource.create(scopeObj.toApiObject(object),
          function(successResponse, responseHeaders){
            scopeObj.collection.push(successResponse);
            if(angular.isFunction(success)){
              success(successResponse, responseHeaders);
            }
          }, function(failureResponse, responseHeaders){
            if(angular.isFunction(failure)){
              failure(failureResponse, responseHeaders);
            }
          })
      }
    }
    function updateFunction(scopeObj){
      return function(object, success, failure){
        scopeObj.resource.update(scopeObjtoApiObject(object),
          function(successResponse, responseHeaders){
            for(var i = 0; i < scopeObj.collection.length; i++){
              if(scopeObj.collection[i].id === successResponse.id){
                for(var prop in successResponse){
                  scopeObj.collection[i][prop] = successResponse[prop];
                }
                break;
              }
            }
            if(angular.isFunction(success)){
              success(successResponse, responseHeaders);
            }
          }, function(failureResponse, responseHeaders){
            if(angular.isFunction(failure)){
              failure(failureResponse, responseHeaders);
            }
          })
      }
    }
    function destroyFunction(scopeObj){
      return function(object, success, failure){
        scopeObj.resource.destroy(scopeObj.toApiObject(object),
          function(successResponse, responseHeaders){
            for(var i = 0; i < scopeObj.collection.length; i++){
              if(scopeObj.collection[i].id === successResponse.id){
                scopeObj.collection.splice(i, 1);
                break;
              }
            }
            if(angular.isFunction(success)){
              success(successResponse, responseHeaders);
            }
          }, function(failureResponse, responseHeaders){
            if(angular.isFunction(failure)){
              failure(failureResponse, responseHeaders);
            }
          });
      }
    }
    var CollectionResource = function(url, options, actions){
      this.resource = $resource($window.prefixWithLocale(url), options, actions);

      if(angular.isDefined(actions.index)){
        this.index = indexFunction(this);
      }

      if(angular.isDefined(actions.create)){
        this.create = createFunction(this);
      }

      if(angular.isDefined(actions.update)){
        this.update = updateFunction(this);
      }

      if(angular.isDefined(actions.destroy)){
        this.destroy = destroyFunction(this);
      }
    };
    CollectionResource.prototype.collection = [];
    CollectionResource.prototype.toApiObject = function(object){return object };
    return CollectionResource;
  });
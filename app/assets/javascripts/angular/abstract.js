angular.module('Kassa.Abstract',['ngResource'])
  .factory('collectionResource', function($resource, $window){

    function addDefaultOptions(object){
      var DEFAULT_ACTIONS = {
        index: {method:'GET'},
        create: {method:'POST'},
        update: {method: 'PUT'},
        destroy: {method: 'DELETE'}
      };
      var DEFAULT_RESPONSE_FILTERS = {
        index: function(resp){
          return resp.collection
        },
        create: function(resp){
          return resp.object
        },
        update: function(resp){
          return resp.object
        },
        destroy:function(resp){
          return resp.object
        }
      };
      if(angular.isUndefined(object.options)){
        object.options = {}
      }
      if(angular.isUndefined(object.actions)){
        object.actions = DEFAULT_ACTIONS
      }
      if(angular.isUndefined(object.decodeFromApi)){
        object.decodeFromApi = function(objectForFiltering){
          return objectForFiltering;
        }
      }
      if(angular.isUndefined(object.encodeForApi)){
        object.encodeForApi = function(objectForFiltering){
          return objectForFiltering;
        }
      }
      if(angular.isUndefined(object.responseFilters)){
        object.responseFilters = DEFAULT_RESPONSE_FILTERS;
      }else{
        angular.forEach(object.actions, function(value, key){
          if(!angular.isFunction(object.responseFilters[key])){
            object.responseFilters[key] = DEFAULT_RESPONSE_FILTERS[key]
          }
        });
      }
    }
    function indexFunction(scopeObj){
      return function(options, success, failure){
        scopeObj.resource.index(options,
          function(successResponse, responseHeaders){
            var filteredResponse = scopeObj.responseFilters.index(successResponse);
            scopeObj.collection.length = 0;
            angular.forEach(filteredResponse, function(object){
              scopeObj.collection.push(scopeObj.decodeFromApi(object))
            });
            if(angular.isFunction(success)){
              success(filteredResponse, responseHeaders);
            }
          }, function(failureResponse, responseHeaders){
            if(angular.isFunction(failure)){
              failure(failureResponse, responseHeaders);
            }
          });
        return scopeObj.collection;
      }
    }
    function createFunction(scopeObj){
      return function(object, success, failure){
        scopeObj.resource.create(scopeObj.encodeForApi(object),
          function(successResponse, responseHeaders){
            var filteredResponse = scopeObj.responseFilters.create(successResponse);
            filteredResponse = scopeObj.decodeFromApi(filteredResponse);
            scopeObj.collection.push(filteredResponse);
            if(angular.isFunction(success)){
              success(filteredResponse, responseHeaders);
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
        scopeObj.resource.update(scopeObj.encodeForApi(object),
          function(successResponse, responseHeaders){
            var filteredResponse = scopeObj.responseFilters.update(successResponse);
            for(var i = 0; i < scopeObj.collection.length; i++){
              if(scopeObj.collection[i].id === filteredResponse.id){
                for(var prop in filteredResponse){
                  scopeObj.collection[i][prop] = filteredResponse[prop];
                }
                break;
              }
            }
            if(angular.isFunction(success)){
              success(filteredResponse, responseHeaders);
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
        scopeObj.resource.destroy(scopeObj.encodeForApi(object),
          function(successResponse, responseHeaders){
            var filteredResponse = scopeObj.responseFilters.destroy(successResponse);
            for(var i = 0; i < scopeObj.collection.length; i++){
              if(scopeObj.collection[i].id === filteredResponse.id){
                scopeObj.collection.splice(i, 1);
                break;
              }
            }
            if(angular.isFunction(success)){
              success(filteredResponse, responseHeaders);
            }
          }, function(failureResponse, responseHeaders){
            if(angular.isFunction(failure)){
              failure(failureResponse, responseHeaders);
            }
          });
      }
    }
    function CollectionResourceFactory(options){
      addDefaultOptions(options);
      var collectionResource = {
        resource: $resource($window.Kassa.prefixWithLocale(options.url), options.options, options.actions),
        collection: [],
        encodeForApi: options.encodeForApi,
        decodeFromApi: options.decodeFromApi,
        responseFilters: options.responseFilters
      };
      if(angular.isObject(options.actions.index)){
        collectionResource.index = indexFunction(collectionResource);
      }

      if(angular.isObject(options.actions.create)){
        collectionResource.create = createFunction(collectionResource);
      }

      if(angular.isObject(options.actions.update)){
        collectionResource.update = updateFunction(collectionResource);
      }

      if(angular.isObject(options.actions.destroy)){
        collectionResource.destroy = destroyFunction(collectionResource);
      }
      return collectionResource
    }
    return CollectionResourceFactory
  });
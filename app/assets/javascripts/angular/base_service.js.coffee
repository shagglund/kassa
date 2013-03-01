angular.module('kassa.common', ['ngResource'])
.factory('BaseService',($q, $resource)->
  class BaseService
    constructor: (url, options, actions)->
      @collection = []
      @resource = $resource url, options, actions
      @_setupActionMethods actions
    
    entries: =>
      @collection

    _add: (items...)=>
      @collection.push item for item in items

    _update: (item)=>
      return @collection[i]=item for it, i in @collection when it.id == item.id

    _remove: (item)=>
      return @collection.splice i,1 for it, i in @collection when it.id == item.id

    _defer: (actionFunc, options)=>
      deferred = $q.defer()
      actionFunc options, deferred.resolve, deferred.reject
      deferred.promise

    _encode: (item)=>
      item
    
    _handleResponse: (action, response, responseHeaders)->
      return

    _setupActionMethods: (actions)=>
      if angular.isDefined actions.index
        @index = (options)=>
          deferred = @_defer @resource.index, options
          deferred.then (response, responseHeaders)=>
            @_handleResponse 'index', response, responseHeaders
            @collection.length = 0
            @_add response.collection
            @collection

      if angular.isDefined actions.create
        @create = (item)=>
          deferred = @_defer @resource.create, @_encode item
          deferred.then (response, responseHeaders)=>
            @_handleResponse 'create', response, responseHeaders
            @_add response.object
            response.object

      if angular.isDefined actions.update
        @update = (item)=>
          deferred = @_defer @resource.update, @_encode item
          deferred.then (response, responseHeaders)=>
            @_handleResponse 'update', response, responseHeaders
            @_update item
            item

      if angular.isDefined actions.destroy
        @destroy = (item)=>
          deferred = @_defer @resource.destroy, {id: item.id}
          deferred.then (response, responseHeaders)=>
            @_handleResponse 'destroy', response, responseHeaders
            @_remove item
            item
)

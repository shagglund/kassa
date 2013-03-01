angular.module('kassa.common', ['ngResource'])
.factory('BaseService',($q, $resource)->
  class BaseService
    constructor: (url, options, actions)->
      @collection = []
      @resource = $resource url, options, actions
      @_setupActionMethods actions
    
    entries: =>
      @collection

    _updateLocally: (item)=>
      return @collection[i]=item for it, i in @collection when it.id == item.id

    _removeLocally: (item)=>
      return @collection.splice i,1 for it, i in @collection when it.id == item.id

    _defer: (actionFunc, options)=>
      deferred = $q.defer()
      actionFunc options, deferred.resolve, deferred.reject
      deferred.promise

    _encode: (item)=>
      item

    _add: (items...)=>
      @collection.push item for item in items

    _setupActionMethods: (actions)=>
      if angular.isDefined actions.index
        @index = (options)=>
          deferred = @_defer @resource.index, options
          deferred.then (response)=>
            @collection.length = 0
            @_add response.collection
            @collection

      if angular.isDefined actions.create
        @create = (item)=>
          deferred = @_defer @resource.create, @_encode item
          deferred.then (response)=>
            @_add response.object
            response.object

      if angular.isDefined actions.update
        @update = (item)=>
          @_defer @resource.update, @_encode item

      if angular.isDefined actions.destroy
        @destroy = (item)=>
          deferred = @_defer @resource.destroy, {id: item.id}
)

angular.module('kassa.users', ['ngResource'])
.service('Users', ($resource)->
  class Users
    constructor:($resource)->
      options =
        id: '@id'
      actions=
        index:
          method: 'GET'
        create:
          method: 'POST'
        update:
          method: 'PUT'
      @resource = $resource '/users/:id', options, actions
      @collection = []

    index: (options={})=>
      deferred = @resource.index options
      deferred.then (response)=>
        @collection.length = 0
        @collection.push response.collection...
      deferred

    create: (user)=>
      deferred = @resource.create @_encode user
      deferred.then (response)=>
        @collection.push response.object
      deferred

    update: (user)=>
      @resource.update @_encode user

    destroy: (user)=>
      deferred = @resource.destroy user.id
      deferred.then (response)=>
        @_removeLocally user
      deferred

    _encode: (user)->
      r =
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        username: user.username,
        balance: user.balance
    
    _removeLocally: (user)=>
      @collection.splice i,1 for u, i in @collection when u.id == user.id

    _updateLocally: (user)=>
      @collection[i] = user for u, i in @collection when u.id == user.id

  new Users($resource)
).controller('UsersController', ($scope, Users)->
  $scope.users = Users
)

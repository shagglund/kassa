angular.module('kassa.users', ['kassa.common'])
.service('Users', (BaseService)->
  class Users extends BaseService
    constructor: ->
      options =
        id: '@id'
      actions=
        index:
          method: 'GET'
        create:
          method: 'POST'
        update:
          method: 'PUT'
      super '/users/:id', options, actions

    updateChanged: (users...)->
      @_update users...

    findByUsername: (username)->
      return user for user in @entries() when user.username == username

    _encode: (user)->
      retVal =
        id: user.id,
        user:
          id: user.id
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          username: user.username,
          balance: user.balance

  new Users()
).controller('UsersController', ($scope, Users)->
  $scope.users = Users
)

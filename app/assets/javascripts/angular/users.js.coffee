angular.module('kassa.users', ['kassa.common'])
.service('Users', (BaseService)->
  options =
    id: '@id'
  actions=
    index:
      method: 'GET'
    create:
      method: 'POST'
    update:
      method: 'PUT'
  class Users extends BaseService
    constructor: ->
      super '/users/:id', options, actions

    updateChanged: (user)=>
      @_update user

    _encode: (user)->
      r =
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        username: user.username,
        balance: user.balance

  new Users()
).controller('UsersController', ($scope, Users)->
  $scope.users = Users
)

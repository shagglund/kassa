angular.module('Kassa.Users', ['Kassa.Abstract'])
  .service('Users', function(collectionResource, $window){
    var resource = collectionResource({
      url:'/users/:id',
      options: {id: '@id'},
      actions:{
        index: {method: 'GET'},
        create: {method: 'POST'},
        update: {method: 'PUT'}
      },
      encodeForApi: function(user){
        return {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          username: user.username,
          balance: user.balance
        }
      }
    });
    var Users = {
      collection: resource.index(),
      index: function(){
        resource.index({}, this.onSuccess,this.onFailure);
        return this.collection;
      },
      create: function(user){
        resource.create(user,this.onSuccess, this.onFailure);
      },
      update: function(user){
        resource.update(user, this.onSuccess, this.onFailure);
      },
      //overridable callback for custom application wide error handling
      onFailure: function(response,responseHeaders){
        console.log(response);
        console.log(responseHeaders);
      },
      //overridable callback for custom application wide success handling
      onSuccess: function(response, responseHeaders){},
      updateChangedUser: function(user){
        angular.forEach(this.collection, function(oldUser){
          if(oldUser.id === user.id){
            $window.Kassa.update(user, oldUser);
          }
        })
      },
      findByUsername: function(username){
        for(var id in this.collection){
          if(this.collection.hasOwnProperty(id)){
            if(angular.isString(this.collection[id].username)
              && this.collection[id].username === username){
              return this.collection[id]
            }
          }
        }
        return undefined
      }
    };
    return Users;
  }).controller('UsersController', function($scope, Users, Basket){
    $scope.users = Users;
    $scope.basket = Basket;
  });
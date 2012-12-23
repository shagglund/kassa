angular.module('Kassa.Users', ['Kassa.Abstract'])
  .service('Users', function(CollectionResource){
    var resource = CollectionResource('/users/:id', {id: '@id'}, {
      index: {method: 'GET', isArray: true},
      create: {method: 'POST'},
      update: {method: 'PUT'}
    });
    resource.toApiObject = function(user){
      return {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        username: user.username,
        balance: user.balance
      }
    };
    var Users = {
      index: function(){
        resource.index({}, this.onSuccess,this.onFailure);
        return resource.collection;
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
      onSuccess: function(response, responseHeaders){}
    };
    return Users;
  });
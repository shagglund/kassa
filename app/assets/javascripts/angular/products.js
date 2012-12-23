angular.module('Kassa.Products', ['Kassa.Abstract'])
  .service('Products', function(CollectionResource){
    var resource = CollectionResource('/products/:id', {id: '@id'},{
      index: {method: 'GET', isArray: true},
      create: {method: 'POST'},
      update: {method: 'PUT'},
      destroy: {method: 'DELETE'}
    });
    resource.toApiObject = function(product){
      var filtered = {
        id: product.id,
        name: product.name,
        description: product.description,
        unit: product.unit,
        group: product.group,
        materials_attributes: []
      };
      angular.forEach(product.materials, function(entry){
        filtered.materials_attributes.push({
          id: entry.id,
          amount: entry.amount,
          material_id: entry.material.id
        });
      });
      return filtered;
    };
    var Products = {
      index: function(){
        resource.index({},this.onSuccess, this.onFailure);
        return resource.collection;
      },
      create: function(buy){
        resource.create(buy, this.onSuccess, this.onFailure);
      },
      update: function(buy){
        resource.update(buy, this.onSuccess, this.onFailure);
      },
      destroy: function(buy){
        resource.destroy(buy, this.onSuccess, this.onFailure);
      },
      //overridable callback for custom application wide error handling
      onFailure: function(response,responseHeaders){
        console.log(response);
        console.log(responseHeaders);
      },
      //overridable callback for custom application wide success handling
      onSuccess: function(response, responseHeaders){}
    };
    return Products;
  }).controller('ProductsController', function($scope, Products){
    $scope.products = Products
  });
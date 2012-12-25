angular.module('Kassa.Products', ['Kassa.Abstract'])
  .service('Products', function(collectionResource, $window){
    function extendProduct(product){
      product.stock = function(){
        var min = -1;
        angular.forEach(product.materials, function(materialBinding){
          var val = Math.floor(materialBinding.material.stock / materialBinding.amount);
          if(val < min || min === -1){
            min = val
          }
        });
        return min
      };
      product.price = function(){
        var price = 0;
        angular.forEach(product.materials, function(materialEntry){
          price += materialEntry.amount * materialEntry.material.price;
        });
        return Math.round(price*100)/100;
      };
      return product
    }
    function modifyDataToRailsForm(product){
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
      return filtered
    }
    function materialId(materialOrId){
      if(angular.isNumber(materialOrId)){
        return materialOrId
      }else{
        return materialOrId.id
      }
    }
    function bindMaterialToEntry(materials, entryMaterials, materialOrId, materialIndex){
      for(var i = 0; i < materials.length; i++){
        if(materials[i].id === materialId(materialOrId)){
          entryMaterials[materialIndex].material = materials[i];
          break;
        }
      }
    }
    function bindAllMaterials(materials, entry){
      for(var i = 0; i < entry.materials.length; i++){
        bindMaterialToEntry(materials, entry.materials, entry.materials[i].material, i)
      }
    }
    function bindMaterialsToProducts(materials, products){
      for(var i = 0; i < products.length; i++){
        bindAllMaterials(materials,products[i])
      }
    }
    var resource = collectionResource({
      url:'/products/:id',
      options: {id: '@id'},
      encodeForApi: modifyDataToRailsForm,
      decodeFromApi: extendProduct,
      responseFilters: {
        index: function(response){
          bindMaterialsToProducts(response.materials, response.collection);
          Products.materialCollection = response.materials
          //return the products collection with mapped materials
          return response.collection
        }
      }
    });
    var Products = {
      collection: resource.index(),
      materialCollection: [],
      index: function(){
        resource.index({},this.onSuccess, this.onFailure);
        return this.collection;
      },
      create: function(product){
        resource.create(product, this.onSuccess, this.onFailure);
      },
      update: function(product){
        resource.update(product, this.onSuccess, this.onFailure);
      },
      destroy: function(product){
        resource.destroy(product, this.onSuccess, this.onFailure);
      },
      //overridable callback for custom application wide error handling
      onFailure: function(response,responseHeaders){
        console.log(response);
        console.log(responseHeaders);
      },
      //overridable callback for custom application wide success handling
      onSuccess: function(response, responseHeaders){},
      updateChangedMaterials: function(materials){
        angular.forEach(this.materialCollection, function(oldMaterial){
          angular.forEach(materials, function(newMaterial){
            if(newMaterial.id === oldMaterial.id){
              $window.Kassa.update(newMaterial, oldMaterial);
            }
          })
        })
      },
      updateChangedProducts: function(products){
        angular.forEach(this.collection, function(oldProduct){
          angular.forEach(products, function(newProduct){
            if(newProduct.id === oldProduct.id){
              $window.Kassa.update(newProduct, oldProduct);
            }
          })
        })
      }
    };
    return Products;
  }).controller('ProductsController', function($scope, Products, Basket){
    $scope.products = Products;
    $scope.basket = Basket;
  });
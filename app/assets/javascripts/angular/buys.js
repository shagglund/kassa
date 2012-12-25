angular.module('Kassa.Buys', ['Kassa.Abstract', 'Kassa.Products', 'Kassa.Users'])
  .service('Buys', function(collectionResource, Products, Users){
    var resource = collectionResource({
      url: '/buys',
      actions: {
        index: {method: 'GET'},
        create: {method: 'POST'}
      },
      encodeForApi: function(buy){
        var filtered = {
          buyer_id: buy.buyer.id,
          products_attributes: []
        };
        angular.forEach(buy.products, function(entry){
          filtered.products_attributes.push({product_id: entry.product.id, amount: entry.amount});
        });
        return filtered
      },
      responseFilters:{
        create: function(response){
          Products.updateChangedMaterials(response.materials);
          Users.updateChangedUser(response.object.buyer);
          Buys._addBuy(response.object);
          return response.object
        }
      }
    });
    var Buys = {
      collection: resource.index(),
      index: function(success, failure){
        resource.index({}, success, failure);
        return this.collection;
      },
      create: function(buy,success, failure){
        resource.create(buy, success, failure);
      },
      _addBuy: function(buy){
        this.collection.unshift(buy);
      }
    };
    return Buys;
  }).service('Basket', function(Buys, $timeout){
    var Basket = {
      products: [],
      buyStatus: function(status){
        if(angular.isDefined(status)){
          this.__status = status;
          $timeout(function(){
            Basket.__status = ''
          }, 2000);
        }
        return this.__status
      },
      price: function(){
        var price = 0.0;
        for(var i = 0; i < this.products.length; i++){
          price += this.products[i].price()
        }
        return price
      },
      removeProduct: function(productOrIndex){
        var removed;
        if(angular.isNumber(productOrIndex)){
          //remove the product at index
          this.products.splice(productOrIndex, 1);
        }else{
          //find the product and remove it
          for(var i=0;i < this.products.length;i++){
            if(this.products[i].id === productOrIndex.id){
              this.products.splice(i, 1);
              break;
            }
          }
        }
      },
      addProduct: function(product){
        //increment the old entrys amount if it exists
        for(var i=0;i<this.products.length;i++){
          if(this.products[i].product.id === product.id){
            this.products[i].amount++;
            return;
          }
        }

        //otherwise create a new entry
        this.products.push({
          product: product,
          amount: 1,
          positiveAmount: function(){
            return angular.isNumber(this.amount) && this.amount > 0
          },
          enoughInStock: function(){
            return (this.amount || 0) < this.product.stock()
          },
          isValid: function(){
            return this.positiveAmount() && this.enoughInStock()
          },
          price: function(){
            return this.product.price() * (this.amount || 0)
          }
        });
      },
      setBuyer: function(user){
        if(angular.isDefined(user)){
          this.buyer = user;
        }else{
          this.buyer = undefined;
        }
      },
      buy: function(success, failure){
        Buys.create(this, function(successResponse, responseHeaders){
          Basket.clear();
          if(angular.isFunction(success)){
            success(successResponse, responseHeaders)
          }
        }, failure)
      },
      clear: function(){
        this.products.length = 0;
        this.setBuyer();
      },
      hasProducts: function(){
        return this.products.length > 0
      },
      hasValidBuyer: function(){
        return angular.isDefined(this.buyer)
      },
      hasValidProducts: function(){
        for(var i=0; i < this.products.length; i++){
          if(!this.products[i].isValid()){
            return false
          }
        }
        return true
      },
      canBuy: function(){
        return this.hasProducts() && this.hasValidProducts()
          && this.hasValidBuyer()
      }
    };
    return Basket;
  }).controller('BuysController', function($scope, Buys){
    $scope.buys = Buys
  }).controller('BasketController', function($scope, Basket, Users, Products){
    $scope.basket = Basket
    $scope.$watch('basket.buyer', function(selectedUser, oldSelection){
      if(angular.isObject(selectedUser)){
        $scope.buyerName = selectedUser.username
      }else{
        $scope.buyerName = ''
      }
    });
    $scope.findBuyerByName = function(username){
      for(var i = 0; i < Users.collection.length; i++){
        if(Users.collection[i].username.toLowerCase() === username.toLowerCase()){
          Basket.buyer = Users.collection[i];
          return Basket.buyer
        }
      }
      $scope.buyer = undefined
    };
    $scope.validBuyer= function(){
      return angular.isDefined($scope.buyerName)
        && angular.isDefined(Basket.buyer)
        && $scope.buyerName === Basket.buyer.username
    };
    $scope.empty = function(obj){
      return angular.isUndefined(obj) || obj.length === 0
    };
    $scope.clearBuyer = function(){
      $scope.buyerName = undefined;
      Basket.setBuyer();
    };
  });
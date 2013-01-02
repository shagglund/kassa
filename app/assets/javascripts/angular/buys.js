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
      responseFilters: {
        create: function(response){
          Products.updateChangedMaterials(response.materials);
          Users.updateChangedUser(response.object.buyer);
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
      latest: function(){
        var latest = [];
        for(var prop in this.collection){
          if(this.collection.hasOwnProperty((prop))
            && angular.isObject(this.collection[prop])){
            latest.push(this.collection[prop])
          }
        }
        latest.sort(function(first, second){
          return Date.parse(second.created_at) - Date.parse(first.created_at)
        });
        return latest.splice(0,10);
      }
    };
    return Buys;
  }).service('Basket', function(Buys, $timeout){
    var Basket = {
      products: {
        collection:{},
        price: 0.0,
        size: 0,
        add: function(product){
          if(angular.isObject(this.collection[product.id])){
            this.collection[product.id].amount++
          }else{
            this.collection[product.id] = {
              product: product,
              amount: 1,
              positiveAmount: function(){
                return angular.isNumber(this.amount) && this.amount > 0
              },
              enoughInStock: function(){
                return (this.amount || 0) <= this.product.stock()
              },
              isValid: function(){
                return this.positiveAmount() && this.enoughInStock()
              },
              price: function(){
                return this.product.price() * (this.amount || 0)
              }
            }
          }
          this.price += product.price();
          this.size++;
        },
        remove: function(product){
          console.log(this.collection[product.id])
          this.price -= this.collection[product.id].price();
          this.size -= this.collection[product.id].amount;
          delete this.collection[product.id]
        },
        clear: function(){
          this.collection = {};
          this.price = 0.0;
          this.size = 0
        },
        isValid: function(){
          for(var prop in this.collection){
            if(angular.isFunction(this.collection[prop].isValid)
              && !this.collection[prop].isValid()){
              return false
            }
          }
          return true
        }
      },
      price: function(){
        return this.products.price
      },
      removeProduct: function(product){
        this.products.remove(product)
      },
      addProduct: function(product){
        this.products.add(product);
      },
      setBuyer: function(user){
        if(angular.isDefined(user)){
          this.buyer = user;
        }else{
          this.buyer = undefined;
        }
      },
      buy: function(success, failure){
        Buys.create({buyer: this.buyer, products: this.products.collection},
          function(successResponse, responseHeaders){
            Basket.clear();
            if(angular.isFunction(success)){
              success(successResponse, responseHeaders)
            }
          }, failure)
      },
      clear: function(){
        this.products.clear();
        this.setBuyer();
      },
      hasProducts: function(){
        return this.products.size > 0
      },
      hasValidBuyer: function(){
        return angular.isDefined(this.buyer)
      },
      hasValidProducts: function(){
        if(!this.hasProducts()){
          return false
        }
        return this.products.isValid()
      },
      canBuy: function(){
        return this.hasValidProducts() && this.hasValidBuyer()
      }
    };
    return Basket;
  }).controller('BuysController', function($scope, Buys){
    $scope.buys = Buys
  }).controller('BasketController', function($scope, Basket, Users, Products){
    $scope.basket = Basket;
    $scope.$watch('basket.buyer', function(selectedUser, oldSelection){
      if(angular.isObject(selectedUser)){
        $scope.buyerName = selectedUser.username
      }else{
        $scope.buyerName = ''
      }
    });
    $scope.findBuyerByName = function(username){
      Basket.buyer = Users.findByUsername(username)
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
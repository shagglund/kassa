angular.module('Kassa.Buys', ['Kassa.Abstract', 'Kassa.Products', 'Kassa.Users', 'ui.bootstrap.modal'])
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
        angular.forEach(this.collection, function(buy){
          latest.push(buy)
        });
        latest.sort(function(first, second){
          return Date.parse(second.created_at) - Date.parse(first.created_at)
        });
        return latest.splice(0,10);
      }
    };
    return Buys;
  })
  .service('Basket', function(Buys, $timeout){
    var Basket = {
      products: {
        collection:{},
        add: function(product){
          if(this.exists(product)){
            if(this.collection[product.id].product.stock() > this.collection[product.id].amount)
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
              },
              increaseAmount: function(){
                if(this.amount < this.product.stock()){
                  this.amount++;
                }
              },
              decreaseAmount: function(){
                if(this.amount > 1){
                  this.amount--;
                }
              }
            }
          }
        },
        remove: function(product){
          delete this.collection[product.id]
        },
        exists: function(product){
          return angular.isObject(this.collection[product.id])
        },
        clear: function(){
          this.collection = {};
        },
        isValid: function(){
          var rv = true;
          angular.forEach(this.collection, function(product){
            if(rv) rv = product.isValid();
          });
          return rv;
        },
        amountOf: function(product){
          if(this.exists(product)){
            return this.collection[product.id].amount
          }
          return 0
        }
      },
      price: function(){
        var price = 0.0;
        angular.forEach(this.products.collection, function(entry){
          price += entry.price();
        });
        return price;
      },
      removeProduct: function(product){
        this.products.remove(product)
      },
      addProduct: function(product){
        this.products.add(product);
      },
      hasProduct: function(product){
        return this.amountOf(product) > 0
      },
      amountOf: function(product){
        if(this.products.exists(product)){
          return this.products.collection[product.id].amount
        }
        return 0
      },
      setBuyer: function(user){
        if(angular.isDefined(user) && this.buyer !== user){
          this.buyer = user;
        }else{
          this.buyer = undefined;
        }
      },
      hasBuyer: function(user){
        if(user){
          return this.buyer === user;
        }else{
          return angular.isDefined(this.buyer);
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
      hasValidBuyer: function(){
        return angular.isDefined(this.buyer)
      },
      hasValidProducts: function(){
        if(this.productCount() == 0) return false;
        return this.products.isValid()
      },
      productCount: function(){
        var count = 0;
        angular.forEach(this.products.collection, function(entry){
          //to prevent silly behavior in UI when editing amounts straight on input
          //without this check productCount could return 0 if only a single product is in basket
          count += entry.amount ? entry.amount : 1;
        });
        return count
      },
      canBuy: function(){
        return this.hasValidProducts() && this.hasValidBuyer()
      }
    };
    return Basket;
  })
  .controller('BuysController', function($scope, Buys){
    $scope.buys = Buys
  })
  .controller('BasketController', function($scope, Basket, Users){
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
    $scope.openBasket = function(){
      $scope.basketShouldBeOpen = true;
    };
    $scope.buyAndCloseBasket = function($event){
      Basket.buy();
      $scope.closeBasket($event);
    };
    $scope.clearAndCloseBasket = function($event){
      Basket.clear();
      $scope.closeBasket($event);
    };
    $scope.closeBasket = function($event){
      $scope.basketShouldBeOpen = false;
      $event.stopPropagation();
      $event.preventDefault();
    }
  });
angular.module('Kassa.Basket', ['Kassa.Buys'])
  .service('Basket', function(Buys){
    var Basket = {
      products: [],
      removeProduct: function(product_or_index){
        if(angular.isNumber(product_or_index)){
          this.products.splice(product_or_index, 1);
        }else{
          for(var i=0;i < this.products.length;i++){
            if(product.id === product_or_index.id){
              this.products.splice(i, 1);
              break;
            }
          }
        }
      },
      addProduct: function(product){
        for(var productEntry in this.products){
          if(productEntry.product.id === product.id){
            productEntry.amount++;
            return;
          }
        }

        this.products.push({product: product, amount: 1})
      },
      setBuyer: function(user){
        if(angular.isDefined(user)){
          this.buyer = user;
        }else{
          this.buyer = undefined;
        }
      },
      buy: function(success, failure){
        Buys.create(this, success, failure)
      },
      clear: function(){
        this.products.length = 0;
        this.setBuyer();
      },
      hasProducts: function(){
        return this.products.length > 0
      },
      canBuy: function(){
        return this.hasProducts() && angular.isDefined(this.buyer)
      }

    };
    return Basket;
  });
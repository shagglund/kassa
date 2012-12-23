angular.module('Kassa.Buys', ['Kassa.Abstract'])
  .service('Buys', function(CollectionResource){
    var resource = CollectionResource('/buys',{}, {
      index:{method: 'GET',isArray: true},
      create:{method: 'POST'}
    });
    //override toApiObject to do actual filtering
    resource.toApiObject = function(buy){
      var filtered = {
        buyer_id: buy.buyer.id,
        products_attributes: {}
      };
      angular.forEach(buy.products, function(entry){
        filtered.push({product_id: entry.product.id, amount: entry.amount});
      });
      return filtered;
    };
    var Buys = {
      index: function(){
        resource.index({}, this.onSuccess, this.onFailure);
        return resource.collection;
      },
      create: function(buy){
        resource.create(buy, this.onSuccess, this.onFailure);
      },
      //overridable callback for custom application wide error handling
      onFailure: function(response,responseHeaders){
        console.log(response);
        console.log(responseHeaders);
      },
      //overridable callback for custom application wide success handling
      onSuccess: function(response, responseHeaders){}
    };
    return Buys;
  });
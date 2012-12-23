angular.module('Kassa', ['Kassa.Buys', 'Kassa.Products', 'Kassa.Users', 'Kassa.Basket', 'Kassa.Session'])
  .config(function($routeProvider){
    $routeProvider.when('/buys', {
      templateUrl: '/partials/buys.html',
      controller: 'BuysController'
    });
    $routeProvider.when('/products', {
      templateUrl: '/partials/products.html',
      controller: 'ProductsController'
    });
    $routeProvider.when('/users', {
      templateUrl: '/partials/users.html',
      controller: 'UsersController'
    });
    $routeProvider.otherwise({redirectTo: '/'});
  }).run(function($rootScope, $http){
    $rootScope.filter = function(items, field, filterList){
      //Does not allow for arrays as item
      function findInnermostValue(item, fieldNames, filterList){
        if(fieldNames.length > 1){
          return findInnermostValue(item[fieldNames.shift()], fieldNames, filterList)
        }else{
          return item[fieldNames]
        }
      }
      function containsStringInList(haystack, needleList){
        function containsString(haystack, needle){
          return haystack.toLowerCase().indexOf(needle.toLowerCase()) > -1;
        }
        angular.forEach(needleList, function(needle){
          if(containsString(haystack, needle)){
            return true;
          }
        });
        return needleList.length == 0;
      }

      function maybeHide(item, fieldNames){
        var value = findInnermostValue(items,fieldNames,filterList)
        if(!angular.isUndefined(value)){
          item.hidden = !containsStringInList(value, filterList)
        }
      }

      //allow for dot notated inner properties ie. 'material.name'
      var fieldNames = field.split('.')
      if(angular.isArray(items)){
        angular.forEach(items,function(item){
          maybeHide(item, fieldNames)
        });
      }else{
        maybeHide(items, fieldNames)
      }
    };

    var token = $("meta[name='csrf-token']").attr("content")
    if(token !== undefined){
      $http.defaults.headers.post['X-CSRF-Token'] = token
      $http.defaults.headers.put['X-CSRF-Token'] = token
      $http.defaults.headers.delete = {'X-CSRF-Token': token}
    }
  });
angular.module('Kassa', ['Kassa.Buys', 'Kassa.Products', 'Kassa.Users', 'Kassa.Session', 'Kassa.Navigation'])
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
    $routeProvider.when('/login',{
     templateUrl: '/partials/login.html',
     controller: 'SessionController'
    });
    $routeProvider.otherwise({redirectTo: '/login'});
  }).run(function($rootScope, $http){
    var token = $("meta[name='csrf-token']").attr("content")
    if(token !== undefined){
      $http.defaults.headers.post['X-CSRF-Token'] = token
      $http.defaults.headers.put['X-CSRF-Token'] = token
      $http.defaults.headers.delete = {'X-CSRF-Token': token}
    }

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
        if(angular.isArray(needleList)){
          for(var i = 0; i<needleList.length; i++){
            if(containsString(haystack, needleList[i])){
              return true;
            }
          }
        }else{
          if(containsString(haystack, needleList)){
            return true;
          }
        }
        return needleList.length == 0;
      }

      function maybeHide(item, fieldNames){
        var value = findInnermostValue(item,fieldNames,filterList)
        if(angular.isDefined(value)){
          item.hidden = !containsStringInList(value, filterList)
        }
      }

      //allow for dot notated inner properties ie. 'material.name'
      var fieldNames = field.split('.');
      for(var prop in items){
        if(items.hasOwnProperty((prop))){
          maybeHide(items[prop], fieldNames)
        }
      }
    };
  });
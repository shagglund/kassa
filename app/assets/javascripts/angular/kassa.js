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
    $rootScope.filter = function(items, field, filterList){
      console.log(filterList)
      //Does not allow for arrays as item
      function findInnermostValue(item, fieldNames, filterList){
        if(fieldNames.length > 1){
          return findInnermostValue(item[fieldNames.shift()], fieldNames, filterList)
        }else{
          console.log()
          console.log('Found single value for ' + fieldNames + ':' + angular.toJson(item[fieldNames]));
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
              console.log(haystack + 'matched ' + needleList[i]);
              return true;
            }
          }
        }else{
          if(containsString(haystack, needleList)){
            console.log(haystack + 'matched ' + needleList);
            return true;
          }
        }
        return needleList.length == 0;
      }

      function maybeHide(item, fieldNames){
        var value = findInnermostValue(item,fieldNames,filterList)
        if(angular.isDefined(value)){
          console.log('Checking for value: ' + value)
          item.hidden = !containsStringInList(value, filterList)
          if(item.hidden){
            console.log("Hid " + angular.toJson(item))
          }
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
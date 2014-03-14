angular.module('kassa').service('ProductService',[
  '$http'
  '$routeParams'
  ($http, $routeParams)->
    index = -> $http.get('/products')
    get = (id)-> $http.get("/products/#{id}")

    all = -> index().then (resp)-> resp.data.products
    find = (id)-> get(id).then (resp)-> resp.data.product
    currentByRoute = -> find($routeParams.id)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
    }
])
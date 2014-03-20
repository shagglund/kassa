angular.module('kassa').service('ProductService',[
  '$http'
  '$routeParams'
  ($http, $routeParams)->
    #handle price as a float, not a string
    convert = (resp)->
      products = Array(resp.data.products || resp.data.product)
      for product in products
        product.price = parseFloat(product.price)
      resp

    index = -> $http.get('/products').then convert
    get = (id)-> $http.get("/products/#{id}").then convert

    all = -> index().then (resp)-> resp.data.products
    find = (id)-> get(id).then (resp)-> resp.data.product
    currentByRoute = -> find($routeParams.id)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
    }
])
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

    destructure = (resp)-> resp.data.product || resp.data.products

    all = -> $http.get('/products').then(convert).then(destructure)

    find = (id)-> $http.get("/products/#{id}").then(convert).then(destructure)

    currentByRoute = -> find($routeParams.id)

    update = (product)-> $http.put("/products/#{product.id}", product: product).then(convert).then(destructure)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
      update: update
    }
])
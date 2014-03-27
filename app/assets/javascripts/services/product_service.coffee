angular.module('kassa').service('ProductService',[
  '$http'
  '$routeParams'
  '$rootScope'
  ($http, $routeParams, $rootScope)->
    #handle price as a float, not a string
    convertProduct = (product)->
      product.price = parseFloat(product.price)

    convert = (resp)->
      products = resp.data.products
      if products?
        convertProduct(product) for product in products
      else
        convertProduct(resp.data.product)
      resp

    getFromResponse = (resp)-> resp.data.product || resp.data.products

    broadcastNewProduct = (product)->
      $rootScope.$broadcast 'product:new', product
      product

    all = -> $http.get('/products').then(convert).then(getFromResponse)

    find = (id)-> $http.get("/products/#{id}").then(convert).then(getFromResponse)

    currentByRoute = -> find($routeParams.id)

    update = (product)-> $http.put("/products/#{product.id}", product: product).then(convert).then(getFromResponse)

    create = (product)-> $http.post('/products', {product}).then(convert).then(getFromResponse).then(broadcastNewProduct)

    {all, find, currentByRoute, update, create}
])
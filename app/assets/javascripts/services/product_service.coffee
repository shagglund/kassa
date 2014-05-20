angular.module('kassa').factory('ProductService',[
  '$http'
  '$routeParams'
  '$rootScope'
  'CacheService'
  ($http, $routeParams, $rootScope, Cache)->
    [isArray, isObject, isNumber, copy] = [angular.isArray, angular.isObject, angular.isNumber, angular.copy]
    CACHE_PREFIX = 'product'

    #handle price as a float, not a string
    _convertAndCacheProduct = (product)->
      product.price = parseFloat(product.price)
      Cache.set(product, CACHE_PREFIX)

    _convert = (resp)->
      products = resp.data.products
      if products?
        _.forEach products, _convertAndCacheProduct
      else
        _convertAndCacheProduct(resp.data.product)
      resp

    _getFromResponse = (resp)-> resp.data.product || resp.data.products

    _broadcastNewProduct = (product)->
      $rootScope.$broadcast 'product:new', product
      product

    all = ->
      $http.get('/products').then(_convert).then(_getFromResponse).then (products)->
        #rewrite all loader function to use the now fully populated cache
        exports.all = all = -> Cache.getAllByPrefix(CACHE_PREFIX)
        products

    find = (id)->
      Cache.get(id, CACHE_PREFIX).then (product)->
        return product if isObject(product) && isNumber(product.id)
        $http.get("/products/#{id}").then(_convert).then(_getFromResponse)

    currentByRoute = -> find($routeParams.id)

    update = (product)-> $http.put("/products/#{product.id}", product: product).then(_convert).then(_getFromResponse)

    create = (product)-> $http.post('/products', {product}).then(_convert).then(_getFromResponse).then(_broadcastNewProduct)


    $rootScope.$on 'buys:new', (event, buy)->
      _.forEach buy.consistsOfProducts, (buyEntry)->
        Cache.get(buyEntry.productId, CACHE_PREFIX).then (product)->
          if isObject(product)
            buyEntry.product = copy(buyEntry.product, product)
          else
            _convertAndCacheProduct(buyEntry.product)

    exports = {all, find, currentByRoute, update, create}
])
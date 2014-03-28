angular.module('kassa').service('BuyService',[
  '$http'
  '$routeParams'
  '$rootScope'
  ($http, $routeParams, $rootScope)->
    isArray = angular.isArray
    findResource = (itemOrItems, id)->
      if isArray(itemOrItems)
        return item for item in itemOrItems when item.id == id
      else if itemOrItems.id == id
        return itemOrItems

    convertBuy = (buy, buyers, products)->
      buy.price = parseFloat(buy.price)
      buy.buyer = findResource(buyers, buy.buyerId)
      entry.product = findResource(products, entry.productId) for entry in buy.consistsOfProducts
      buy

    convert = (resp)->
      data = resp.data
      buys = data.buys
      if isArray(buys)
        convertBuy(buy, data.buyers, data.products) for buy in buys
      else
        convertBuy(data.buy, data.buyer, data.products)
      resp

    getFromResponse= (resp)-> resp.data.buys || resp.data.buy

    broadcastNewBuy = (buy)->
      $rootScope.$broadcast 'buys:new', buy
      buy

    latest = (params)-> $http.get('/buys', {params}).then(convert).then(getFromResponse)

    all = ()-> latest({})

    find = (id)-> $http.get("/buys/#{id}").then(convert).then(getFromResponse)

    currentByRoute = -> find($routeParams.id)

    latestForUser = (user, params)->
      $http.get("/users/#{user.id}/buys", {params}).then(convert).then(getFromResponse)

    latestForProduct = (product, params)->
      $http.get("/products/#{product.id}/buys", {params}).then(convert).then(getFromResponse)

    create = (buyer, entries)->
      products = entries.map (entry)-> amount: entry.amount, product_id: entry.product.id
      $http.post('/buys', buy: {buyer_id: buyer.id, products}).then(convert).then(getFromResponse).then(broadcastNewBuy)

    {
      all: all
      latest: latest
      find: find
      currentByRoute: currentByRoute
      latestForUser: latestForUser
      latestForProduct: latestForProduct
      create: create
    }
])
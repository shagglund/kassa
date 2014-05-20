angular.module('kassa').factory('BuyService',[
  '$http'
  '$routeParams'
  '$rootScope'
  ($http, $routeParams, $rootScope)->
    findResource = (itemOrItems, id)->
      if _.isArray(itemOrItems)
        _.find itemOrItems, (item)-> item.id == id
      else if itemOrItems.id == id
        return itemOrItems

    convertBuy = (buy, buyers, products)->
      buy.price = parseFloat(buy.price)
      buy.buyer = findResource(buyers, buy.buyerId)
      _.forEach buy.consistsOfProducts, (entry)->
        entry.product = findResource(products, entry.productId)
      buy

    convert = (resp)->
      data = resp.data
      buys = data.buys
      if _.isArray(buys)
        _.forEach buys, (buy)-> convertBuy(buy, data.buyers, data.products)
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
      products = _.map entries, (entry)-> amount: entry.amount, product_id: entry.product.id
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
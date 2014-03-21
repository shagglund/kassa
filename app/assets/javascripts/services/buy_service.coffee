angular.module('kassa').service('BuyService',[
  '$http'
  '$routeParams'
  ($http, $routeParams)->
    convertBuy = (buy)->
      buy.price = parseFloat(buy.price)

    convert = (resp)->
      buys = resp.data.buys
      if buys?
        convertBuy(buy) for buy in buys
      else
        convertBuy(resp.data.buy)
      resp

    getFromResponse= (resp)-> resp.data.buys || resp.data.buy

    all = (params)-> $http.get('/buys', {params}).then(convert).then(getFromResponse)

    find = (id)-> $http.get("/buys/#{id}").then(convert).then(getFromResponse)

    currentByRoute = -> find($routeParams.id)

    latestForUser = (user, count)->
      params = limit: count
      $http.get("/users/#{user.id}/buys", {params}).then(convert).then(getFromResponse)

    latestForProduct = (product, count)->
      params = limit: count
      $http.get("/products/#{product.id}/buys", {params}).then(convert).then(getFromResponse)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
      latestForUser: latestForUser
      latestForProduct: latestForProduct
    }
])
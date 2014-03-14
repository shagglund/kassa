angular.module('kassa').service('BuyService',[
  '$http'
  '$routeParams'
  ($http, $routeParams)->
    index = (params={})-> $http.get('/buys', {params})
    get = (id)-> $http.get("/buys/#{id}")

    all = (params)-> index(params).then (resp)-> resp.data.buys
    find = (id)-> get(id).then (resp)-> resp.data.buy
    currentByRoute = -> find($routeParams.id)

    {
      all: all
      find: find
      currentByRoute: currentByRoute
    }
])
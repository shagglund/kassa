angular.module('Kassa.controllers', ['Kassa.services'])
.controller('BuysController', ($scope, Buys, Basket)->
  class BuysController
    constructor: (@$scope, @Buys, @Basket) ->
      @$scope.latest_buys = @Buys.index()
      @$scope.basket = @Basket
      @$scope.messageType = 'success'
      @$scope.message = ''

      @$scope.productsStr= (products)->
        str_arr = []
        for product in products
          str_arr.push "#{product.amount} #{product.name}"
        str_arr.join(', ')

      @$scope.buy= =>
        @Basket.buy @_handleBuySuccess, @_handleBuyFailure

    _handleBuySuccess: (response, headers)=>
      @$scope.latest_buys = @Buys.index()
      @$scope.showNotification {name: 'buy:success', notification: '#TODO success message', type:'success'}

    _handleBuyFailure: (response,headers)=>
      if response.status == 422
        @$scope.showNotification {name: 'buy:failure', notification: response.data.message, type:'error'}
    #TODO show errors

  new BuysController($scope, Buys, Basket)
)
.controller('SessionsController', ($scope, $location, Session)->
  class SessionsController
    constructor: (@$scope, @$location, @Session)->
      @$scope.credentials = {}
      @$scope.session = @Session
      @$scope.signIn = ()=>
        @Session.signIn @$scope.credentials, ()=>
          @$scope.credentials = {}
      @Session.checkStatus()

  new SessionsController($scope, $location, Session)
)
.controller('UsersController', ($scope, Users, Basket)->
  class UsersController
    constructor: (@$scope, @Users, @Basket)->
      @$scope.basket = @Basket
      @$scope.users = @Users.index()

  new UsersController($scope, Users, Basket)
)
.controller('ProductsController', ($scope, Products, Materials, Basket)->
  class ProductsController
    constructor: (@$scope, @Products, @Materials, @Basket)->
      @$scope.hidden = true
      @$scope.basket = @Basket
      @$scope.products = @Products
      @$scope.materials = @Materials

  new ProductsController($scope, Products, Materials, Basket)
)
.controller('NavigationController', ($scope, $location, Session)->
  class NavigationController
    constructor: (@$scope, @$location, @Session)->
      @$scope.canManageProducts= ()=>
        @Session.signedIn.staff
      @$scope.canManageUsers= ()=>
        @Session.signedIn.admin


  new NavigationController($scope, $location, Session)
)
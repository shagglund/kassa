angular.module('kassa').controller('ProductNewCtrl', [
  '$scope'
  '$location'
  'ProductService'
  'StateService'
  ($scope, $location, Product, State)->
    stateHandler = State.getHandler('ProductNewCtrl:state')

    newProduct = -> {available: true}

    cancel = ->
      $scope.product = newProduct()
      $scope.newProductForm.$setPristine()

    save = (product)->
      goToProduct = (product)->
        $location.path("/products/#{product.id}")
      stateHandler.handleStateChanges Product.create(product).then(goToProduct)

    setPrice = (product, euros=0, cents=0)-> product.price = euros + cents / 100

    $scope.cancel = cancel
    $scope.save = save
    $scope.setPrice = setPrice

    $scope.state = stateHandler

    $scope.product = newProduct()
])
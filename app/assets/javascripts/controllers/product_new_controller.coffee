angular.module('kassa').controller('ProductNewCtrl', [
  '$scope'
  '$location'
  'ProductService'
  ($scope, $location, Product)->
    STATE_FAILED = 0
    STATE_SAVING = 1
    STATE_DEFAULT = 2

    newProduct = -> {available: true}

    cancel = ->
      $scope.product = newProduct()
      $scope.newProductForm.$setPristine()

    save = (product)->
      goToProduct = (product)->
        $location.path("/products/#{product.id}")
      saveFailure = -> $scope.state = STATE_FAILED

      $scope.state = STATE_SAVING
      Product.create(product).then(goToProduct, saveFailure)

    setPrice = (product, euros=0, cents=0)-> product.price = euros + cents / 100

    $scope.cancel = cancel
    $scope.save = save
    $scope.setPrice = setPrice

    $scope.FAILED = STATE_FAILED
    $scope.SAVING = STATE_SAVING
    $scope.DEFAULT = STATE_DEFAULT

    $scope.product = newProduct()
])
angular.module('kassa').controller('ProductDetailCtrl', [
  '$scope'
  'ProductService'
  ($scope, Product)->
    STATE_FAILED = 0
    STATE_SAVED = 1
    STATE_SAVING = 2
    originalProduct = null
    equal = angular.equals

    changed = (product)-> !equal(originalProduct, product)

    cancel = ->
      #copy to prevent any unsaved edits from leaking to server object state
      $scope.product = angular.copy(originalProduct)
      $scope.priceEuro = Math.floor(originalProduct.price)
      $scope.priceCent = (originalProduct.price % 1) * 100

    save = (product)->
      saveSuccess = -> $scope.state = STATE_SAVED
      saveFailure = -> $scope.state = STATE_FAILED
      $scope.state = STATE_SAVING
      Product.update(product).then(setProduct).then saveSuccess, saveFailure

    setProduct = (product)->
      originalProduct = product
      cancel() #sets to default state by copying originalProduct
      product

    updatePrice = (product, euros, cents)->
      console.log 'price before', product.price, typeof product.price
      product.price = euros + cents / 100
      console.log 'price after', product.price, typeof product.price


    Product.currentByRoute().then setProduct
    $scope.changed = changed
    $scope.cancel = cancel
    $scope.save = save
    $scope.updatePrice = updatePrice
    $scope.SAVED = STATE_SAVED
    $scope.FAILED = STATE_FAILED
    $scope.SAVING = STATE_SAVING
])
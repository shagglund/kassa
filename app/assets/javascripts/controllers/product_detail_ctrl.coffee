angular.module('kassa').controller('ProductDetailCtrl', [
  '$scope'
  'ProductService'
  'StateService'
  ($scope, Product, State)->
    stateHandler = State.getHandler('ProductDetailCtrl:state')
    handleStateChanges = stateHandler.handleStateChanges

    originalProduct = null
    equal = angular.equals

    changed = (product)-> !equal(originalProduct, product)

    setProductDataFromOriginal = ->
      #copy to prevent any unsaved edits from leaking to server object state
      $scope.product = angular.copy(originalProduct)
      $scope.priceEuro = Math.floor(originalProduct.price)
      $scope.priceCent = (originalProduct.price % 1) * 100

    save = (product)->
      handleStateChanges Product.update(product).then(setProduct)

    setProduct = (product)->
      originalProduct = product
      setProductDataFromOriginal() #sets to default state by copying originalProduct
      product

    updatePrice = (product, euros, cents)->
      product.price = euros + cents / 100

    Product.currentByRoute().then setProduct
    $scope.changed = changed
    $scope.cancel = setProductDataFromOriginal
    $scope.save = save
    $scope.updatePrice = updatePrice
    $scope.state = stateHandler
])
describe 'BuyUsersListCtrl', ->
  [scope, Basket, User, users] = [null, null, null, []]

  beforeEach(module('kassa'))
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    Basket = {}
    User = {all: jasmine.createSpy().andReturn($q.when(users))}
    $controller('BuyUsersListCtrl', {$scope: scope, BasketService: Basket, UserService: User})

  it 'should assign Basket to scope', ->
    expect(scope.basket).toBe(Basket)

  it 'should load all users when created', ->
    scope.$apply();
    expect(User.all).toHaveBeenCalled()
    expect(scope.users).toBe(users)


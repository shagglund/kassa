describe 'BalanceChangeLatestListCtrl', ->
  #injectable service mocks
  [scope, User, BalanceChange] = [null, null, null]
  #compare data
  [user, balanceChanges] = [{}, []]

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    User = {currentByRoute: jasmine.createSpy().andReturn(user)}
    deferred = $q.defer()
    deferred.resolve(balanceChanges)
    BalanceChange = {all: jasmine.createSpy().andReturn(deferred.promise)}
    $controller('BalanceChangeLatestListCtrl', {$scope: scope, UserService: User, BalanceChangeService: BalanceChange})


  checkBalanceChangesLoaded = ->
    expect(User.currentByRoute).toHaveBeenCalled()
    expect(BalanceChange.all).toHaveBeenCalledWith(user)
    expect(scope.balanceChanges).toBe(balanceChanges)

  it "should load balance changes on creation", ->
    scope.$apply()
    checkBalanceChangesLoaded()

  it "should reload all balance changes on event user:balanceChange", ->
    scope.$apply()
    User.currentByRoute.reset()
    BalanceChange.all.reset()
    scope.$broadcast 'user:balanceChange'
    checkBalanceChangesLoaded()

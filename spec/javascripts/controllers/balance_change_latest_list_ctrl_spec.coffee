describe 'BalanceChangeLatestListCtrl', ->
  #injectable service mocks
  [scope, User, BalanceChange] = [null, null, null]
  #compare data
  [user, balanceChanges] = [{}, []]

  beforeEach module 'kassa'
  beforeEach inject ($controller, $q, $rootScope)->
    scope = $rootScope.$new()
    User = {currentByRoute: jasmine.createSpy().andReturn(user)}
    BalanceChange = {all: jasmine.createSpy().andReturn($q.when(balanceChanges))}
    $controller('BalanceChangeLatestListCtrl', {$scope: scope, UserService: User, BalanceChangeService: BalanceChange})


  checkBalanceChangesLoaded = ->
    expect(User.currentByRoute).toHaveBeenCalled()
    expect(BalanceChange.all).toHaveBeenCalledWith(user)
    expect(scope.balanceChanges).toBe(balanceChanges)

  describe 'initialization', ->

    it "should load all balance changes for a given user", ->
      scope.$apply()
      checkBalanceChangesLoaded()

  describe 'reaction to event: user:balanceChange', ->
    it "should reload all balance changes", ->
      scope.$apply()
      User.currentByRoute.reset()
      BalanceChange.all.reset()
      scope.$broadcast 'user:balanceChange'
      checkBalanceChangesLoaded()

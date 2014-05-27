describe 'orderByStateFilter', ->
  [location, orderByStateFilter] = [null, null]

  testArray = [{orderByState: 1}, {orderByState: 2}]

  setSearchState = (state)->
    location.search()['test'] = if state then 'orderByState:true' else 'orderByState:false'

  beforeEach module 'kassa'
  beforeEach inject ($location, _orderByStateFilter_)->
    location = $location
    orderByStateFilter = _orderByStateFilter_
    setSearchState(true)

  it "should get the order from $location", ->
    spyOn(location, 'search').andCallThrough()
    filtered = orderByStateFilter(testArray, 'test')
    expect(location.search).toHaveBeenCalled()

  it "should be in descending order by 'orderByState' if search is test=orderByState:true", ->
    filtered = orderByStateFilter(testArray, 'test')
    expect(filtered[0].orderByState).toBe(2)

  it "should be in ascending order by 'orderByState' if search is test=orderByState:false", ->
    setSearchState(false)
    filtered = orderByStateFilter(testArray, 'test')
    expect(filtered[0].orderByState).toBe(1)

  it "should return undefined if the passed in array is undefined", ->
    expect(orderByStateFilter()).toBe(undefined)

  it "should return the same array if the passed in array is empty", ->
    testArray = []
    expect(orderByStateFilter(testArray)).toBe(testArray)


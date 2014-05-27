describe 'availableFilter', ->
  beforeEach module 'kassa'

  it "should filter out all objects where obj.available != true", inject (availableFilter)->
    testArray = [{available: false}, {available: true}]
    filtered = availableFilter(testArray)
    expect(filtered.length).toBe(1)
    expect(filtered[0].available).toBe(true)

  it "should return undefined if the passed in array is undefined", inject (availableFilter)->
    expect(availableFilter()).toBe(undefined)

  it "should return the same array if the passed in array is empty", inject (availableFilter)->
    testArray = []
    expect(availableFilter(testArray)).toBe(testArray)


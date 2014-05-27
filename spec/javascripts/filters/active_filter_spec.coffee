describe 'activeFilter', ->
  beforeEach module 'kassa'

  it "should filter out all objects where obj.active != true", inject (activeFilter)->
    testArray = [{active: false}, {active: true}]
    filtered = activeFilter(testArray)
    expect(filtered.length).toBe(1)
    expect(filtered[0].active).toBe(true)

  it "should return undefined if the passed in array is undefined", inject (activeFilter)->
    expect(activeFilter()).toBe(undefined)

  it "should return the same array if the passed in array is empty", inject (activeFilter)->
    testArray = []
    expect(activeFilter(testArray)).toBe(testArray)


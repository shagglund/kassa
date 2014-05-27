describe 'fuzzyMatchFilter', ->
  fuzzyMatchFilter = null

  testArray = [{test: 'ab'}, {test: 'cd'}, {test: 'ef'}]
  testNeedles = ['b', 'c']
  testField = 'test'

  beforeEach module 'kassa'
  beforeEach inject (_fuzzyMatchFilter_)-> fuzzyMatchFilter = _fuzzyMatchFilter_

  it "should return filterable value unless it's an array", ->
    wrongObject = {}
    expect(fuzzyMatchFilter(wrongObject, testNeedles, testField)).toBe(wrongObject)

  it "should return the array to be filtered unless given needles is a non-empty array", ->
    expect(fuzzyMatchFilter(testArray, [], testField)).toBe(testArray)
    expect(fuzzyMatchFilter(testArray, {abc: 'def'}, testField)).toBe(testArray)

  it "should return objects where obj[<test field>] contains any of the needles", ->
    filtered = fuzzyMatchFilter(testArray, testNeedles, testField)
    expect(filtered).toNotBe(testArray)
    expect(_.some(filtered, test: 'ab')).toBe(true)
    expect(_.some(filtered, test: 'cd')).toBe(true)
    expect(_.some(filtered, test: 'ef')).toBe(false)

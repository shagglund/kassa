angular.module('kassa').factory('CacheService', [
  '$q'
  '$parse'
  ($q, $parse)->
    cache = {}
    [isUndefined, isDefined, copy, isString, isNumber] = [angular.isUndefined, angular.isDefined, angular.copy, angular.isString, angular.isNumber]

    getCacheGetterSetter = (prefix, objectIdentity)->
      if isString(prefix) && prefix.length > 0
        $parse("#{prefix}.#{objectIdentity}")
      else if isNumber(objectIdentity)
        #with numeric keys the parser would just return a number, not a setter/getter
        #which is what we need, workaround by prefixing with number.
        #I.e. key 1 -> "number1" in cache collection identity keys
        $parse("number#{objectIdentity}")
      else
        $parse(objectIdentity)

    idBasedIdentity = (obj)-> obj.id

    isCached = (obj, prefix, identity=idBasedIdentity)-> isDefined(getCacheGetterSetter(prefix, identity(obj))(cache))

    set = (objToBeCached, prefix, identity=idBasedIdentity)->
      $q.when(objToBeCached).then (obj)-> getCacheGetterSetter(prefix, identity(obj)).assign(cache, obj)

    #convenience method to get with the default identity function
    get = (obj, prefix, identity=idBasedIdentity)->
      getByIdentity(identity(obj), prefix)

    getByIdentity = (objectIdentity, prefix)->
      $q.when(getCacheGetterSetter(prefix, objectIdentity)(cache))

    getAllByPrefix = (prefix)->
      cachedData = $parse("#{prefix}")(cache)
      if isUndefined(cachedData)
        $q.when([])
      else
        $q.when(_.toArray(cachedData))

    {set, get, isCached, getAllByPrefix, getByIdentity}
])
angular.module('kassa').service('CacheService', [
  '$q'
  '$parse'
  ($q, $parse)->
    cache = {}
    [isUndefined, copy] = [angular.isUndefined, angular.copy]

    _writeToCache = (cacheObj, obj, key)->
      if isUndefined(cacheObj[key])
        cacheObj[key] = obj
      else
        #copy to ensure object references for the cached object stay intact and views are actually updated
        copy(obj, cacheObj[key])

    set = (obj, prefix, field='id')->
      $q.when(obj).then (obj)-> $parse("#{prefix}.#{obj[field]}").assign(cache, obj)

    get = (key, prefix)->
      $q.when $parse("#{prefix}.#{key}")(cache)

    getAllByPrefix = (prefix)->
      cachedData = $parse("#{prefix}")(cache)
      if isUndefined(cachedData)
        $q.when()
      else
        $q.when(_.toArray(cachedData))

    {set, get, getAllByPrefix}
])
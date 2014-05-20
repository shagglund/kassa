angular.module('kassa').factory('CacheService', [
  '$q'
  '$parse'
  ($q, $parse)->
    cache = {}
    [isUndefined, copy] = [angular.isUndefined, angular.copy]

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
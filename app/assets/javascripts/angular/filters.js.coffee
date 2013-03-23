filterFactory = (group)->
  (products)->
    _.filter products, (product)->
      product.attributes.group == group

angular.module('kassa.filters', [])
.filter('beer',->
  filterFactory 'beer'
)
.filter('cider',->
  filterFactory 'cider'
)
.filter('long_drink',->
  filterFactory 'long_drink'
)
.filter('shot',->
  filterFactory 'shot'
)
.filter('drink',->
  filterFactory 'drink'
)
.filter('food',->
  filterFactory 'food'
)
.filter('other',->
  filterFactory 'other'
)

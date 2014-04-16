angular.module('kassa')
.filter('amountNameStringList', ->
  (entries)->
    return '' unless entries?.length > 0
    _.chain(entries).map((entry)-> "#{entry.amount} #{entry.product.name}").join(', ').value()
)
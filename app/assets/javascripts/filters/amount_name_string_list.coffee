angular.module('kassa')
.filter('amountNameStringList', ->
  (entries)->
    return '' unless entries?.length > 0
    ("#{entry.amount} #{entry.product.name}" for entry in entries).join(', ')
)
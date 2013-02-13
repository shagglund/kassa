#=require ./rosie/rosie
Factory.define('user')
  .sequence('id')
  .sequence 'username', (i)->
    "username#{i}"
  .attr('first_name', 'Test')
  .attr('last_name', 'User')
  .attr 'created_at', ()->
    new Date().toUTCString()
  .attr 'balance', ()->
    Math.floor((Math.random()*50)+1)
  .attr 'buy_count', ()->
    Math.floor((Math.random()*100)+1)
  .attr('staff', false)
  .attr('admin', false)

Factory.define('product')
.sequence('id')
.sequence 'name', (i)->
  "product#{i}"
.attr('description', 'description')
.attr('unit', 'piece')
.attr('group', 'can')
.attr 'created_at', ()->
  new Date().toUTCString()
.attr 'materials', ()->
  [
    Factory.attributes('material')
  ]

Factory.define('material')
.sequence('id')
.sequence 'name', (i)->
  "material#{i}"
.attr('unit', 'piece')
.attr('group', 'can')
.attr('price', 0.7)
.attr('stock', 100)


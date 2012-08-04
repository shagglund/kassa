class Kaljakassa.Product extends Batman.Model
  @resourceName: 'product'
  @persist Batman.RestStorage

  @hasMany 'product_entries'

  @encode 'name', 'description', 'unit'
  @encode 'created_at', 'updated_at', Batman.Encoders.railsDate

  @accessor 'price',
    get: (key) ->
      sum = 0
      @get('product_entries').forEach((entry) ->
        sum += entry.get('amount') * entry.get('material.price')
      )
      sum

  @accessor 'stock',
    get: (key) ->
      stock = -1
      @get('product_entries').forEach((entry) ->
        tmp = entry.get('material.stock') / entry.get('amount')
        stock = tmp if tmp < stock or stock == -1
      )


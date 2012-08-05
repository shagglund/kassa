class Kassa.Material extends Batman.Model
  @resourceName: 'material'
  @persist Batman.RestStorage

  @hasMany 'product_entries'

  @encode 'unit', 'name', 'price', 'stock','alcohol_per_cent'
  @encode 'created_at', 'updated_at', Batman.Encoders.railsDate
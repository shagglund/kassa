class Kassa.ProductEntry extends Batman.Model
  @persist Batman.RestStorage

  @belongsTo 'material'
  @belongsTo 'product'

  @encode 'amount'
  @validate 'amount', presence:true, numeric: true, positive: Kassa.Validators.positive
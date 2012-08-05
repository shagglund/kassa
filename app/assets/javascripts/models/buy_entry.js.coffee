class Kassa.BuyEntry extends Batman.Model
  @persist Batman.RestStorage

  @belongsTo 'product'
  @belongsTo 'buy'

  @encode 'amount'
  @validate 'amount', presence: true, numeric: true, positive: Kassa.Validators.positive
  @validate 'product', presence: true
  @validate 'buy', presence: true
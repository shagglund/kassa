class Kassa.Buy extends Batman.Model
  @resourceName: 'buy'
  @persist Batman.RestStorage

  @hasMany 'entries', {name: 'BuyEntry'}
  @belongsTo 'buyer', {name: 'User'}

  @encode 'created_at', Batman.Encoders.railsDate
  @validate 'entries', presence:true, minLength: 1
  @validate 'buyer', presence: true
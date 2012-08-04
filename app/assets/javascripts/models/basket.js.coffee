class Kaljakassa.Basket extends Batman.Model
  @resourceName: 'basket'
  @persist Batman.LocalStorage

  @belongsTo 'buyer', {name: 'User'}

  @encode 'entries',
    encode: (entrySet) -> entrySet.toArray().join(',')
    decode: (entryString) -> new Batman.Set(entryString.split(','))


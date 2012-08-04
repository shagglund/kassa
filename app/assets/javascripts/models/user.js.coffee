class Kaljakassa.User extends Batman.Model
  @resourceName: 'user'
  @persist Batman.RestStorage

  @hasMany 'buys'

  @encode 'username','email','password'
  @encode 'saldo','buy_count', 'admin', 'staff'
  @encode 'created_at', 'updated_at', 'time_of_last_buy', Batman.Encoders.railsDate
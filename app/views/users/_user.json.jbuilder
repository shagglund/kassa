json.cache! ['user', user.id, user.updated_at] do
  json.id user.id
  json.username user.username
  json.email user.email
  json.balance user.balance
  json.admin user.admin
  json.active user.active
  json.buy_count user.buy_count
  json.time_of_last_buy user.time_of_last_buy
  json.updated_at user.updated_at
  json.created_at user.created_at
end
json.cache! cache_key_for_users(users) do
  json.array! users do |user|
    json.partial! 'users/user', user: user
  end
end
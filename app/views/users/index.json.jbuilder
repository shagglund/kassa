json.users do
  json.cache! ['users', @users.map(&:updated_at).max] do
    json.array! @users do |user|
      json.partial! 'users/user', user: user
    end
  end
end
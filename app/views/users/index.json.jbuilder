json.users do
  json.partial! 'users/list', users: @users
end
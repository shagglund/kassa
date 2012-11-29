class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :balance, :buy_count, :admin, :staff, :time_of_last_buy, :created_at, :updated_at
end
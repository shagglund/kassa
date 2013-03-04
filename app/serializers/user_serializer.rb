class UserSerializer < ActiveModel::Serializer
  root :object
  attributes :id, :username,:email, :balance, :buy_count, :admin, :staff, :time_of_last_buy, :created_at, :updated_at
end

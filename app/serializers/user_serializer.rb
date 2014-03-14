class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :balance, :admin, :staff
  attribute :buy_count, key: 'buyCount'
  attribute :time_of_last_buy,  key: 'timeOfLastBuy'
  attribute :updated_at, key: 'updatedAt'
  attribute :created_at, key: 'createdAt'
end
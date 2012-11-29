class BuySerializer < ActiveModel::Serializer
  attributes :id, :price, :created_at
  has_one :buyer
  has_many :products
end
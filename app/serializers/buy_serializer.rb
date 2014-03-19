class BuySerializer < ActiveModel::Serializer
  attributes :id, :price
  attribute :created_at, key: 'createdAt'
  has_many :consists_of_products, key: 'consistsOfProducts'
  has_one :buyer
end
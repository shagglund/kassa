class BuySerializer < ActiveModel::Serializer
  root :object
  attributes :id, :price, :created_at
  has_one :buyer
  has_many :consists_of_products
end

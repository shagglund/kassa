class BuySerializer < ActiveModel::Serializer
  attributes :id, :price, :created_at
  has_one :buyer, embed: :ids, include: true
  has_many :consists_of_products
end

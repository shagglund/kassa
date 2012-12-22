class ProductSerializer < ActiveModel::Serializer
  attributes :id, :price, :stock, :name, :description, :unit, :group, :created_at, :updated_at
  has_many :materials
end
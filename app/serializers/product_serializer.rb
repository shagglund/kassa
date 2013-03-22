class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :group, :created_at, :updated_at
  has_many :consists_of_materials
end

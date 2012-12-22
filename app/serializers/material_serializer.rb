class MaterialSerializer < ActiveModel::Serializer
  attributes :id, :stock, :price, :name, :unit, :group, :created_at, :updated_at
end
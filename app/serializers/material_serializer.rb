class MaterialSerializer < ActiveModel::Serializer
  root :object
  attributes :id, :stock, :price, :name, :unit, :group, :created_at, :updated_at
end
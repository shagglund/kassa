class BasicProductSerializer < ActiveModel::Serializer
  attributes :id, :stock, :price, :name, :unit, 
              :group, :description, :created_at, :updated_at
end

class ComboProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :group, 
              :product_type, :created_at, :updated_at
  has_many :consists_of_basic_products
end

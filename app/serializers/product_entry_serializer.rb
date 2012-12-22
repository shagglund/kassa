class ProductEntrySerializer < ActiveModel::Serializer
  attributes :id, :amount
  has_one :material
end
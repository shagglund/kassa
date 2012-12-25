class ProductEntrySerializer < ActiveModel::Serializer
  embed :ids, :include => true
  attributes :id, :amount
  has_one :material
end
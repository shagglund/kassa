class BuyEntrySerializer < ActiveModel::Serializer
  attributes :id, :amount
  has_one :product
end
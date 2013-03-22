class BuyEntrySerializer < ActiveModel::Serializer
  attributes :id, :amount
  has_one :product, embed: :ids, include: true
end

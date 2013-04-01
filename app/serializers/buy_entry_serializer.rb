class BuyEntrySerializer < ActiveModel::Serializer
  attributes :id, :amount
  has_one :basic_product, key: :product_id, embed: :ids, include: true
  has_one :combo_product, key: :product_id, embed: :ids, include: true

  def include_basic_product?
    object.product.is_a? BasicProduct
  end
  def basic_product
    object.product
  end
  def include_combo_product?
    object.product.is_a? ComboProduct
  end
  def combo_product
    object.product
  end
end

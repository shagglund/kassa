class ProductEntry < ActiveRecord::Base
  audited

  belongs_to :product
  belongs_to :material
  attr_accessible :amount, :material_id, :product_id

  validates_presence_of :product_id, :material_id
  validates :amount, presence: true, numericality: {greater_than_or_equal_to: 1}

  def stock
    material.stock / amount
  end
end

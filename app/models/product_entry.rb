class ProductEntry < ActiveRecord::Base
  belongs_to :product, :touch => true
  belongs_to :material
  attr_accessible :amount, :material, :product

  validates_presence_of :material
  validates_presence_of :product
  validates :amount, numericality: {only_integer: true}, inclusion: {in: 1..999}

  def stock
    material.stock / amount
  end
  
  def price
    material.price * amount
  end
end

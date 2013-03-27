class ProductEntry < ActiveRecord::Base
  belongs_to :combo_product, :touch => true
  belongs_to :basic_product

  validates_presence_of :basic_product
  validates :amount, numericality: {only_integer: true}, inclusion: {in: 1..999}

  def stock
    basic_product.stock / amount
  end
  
  def price
    basic_product.price * amount
  end
end

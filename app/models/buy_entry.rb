class BuyEntry < ActiveRecord::Base
  belongs_to :buy
  belongs_to :product

  validates :product_id, presence: true
  validates :amount, numericality: {only_integer: true}, inclusion: {in: 1..1000}

  def price
    product.price * amount
  end
end

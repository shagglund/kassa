class BuyEntry < ActiveRecord::Base
  belongs_to :buy
  belongs_to :product

  validates :product_id, presence: true
  validates :amount, numericality: {only_integer: true}, inclusion: {in: 1..1000}

  after_create :update_product_buy_count_and_last_bought_at

  def price
    product.price * amount
  end

  protected
  def update_product_buy_count_and_last_bought_at
    product.buy_count += amount
    product.last_bought_at = buy.created_at
    product.save
  end
end

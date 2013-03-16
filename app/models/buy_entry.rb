class BuyEntry < ActiveRecord::Base
  belongs_to :buy
  belongs_to :product
  attr_accessible :amount, :product, :buy

  validates :buy, presence: true
  validates :product, presence: true
  validates :amount, numericality: {only_integer: true}, inclusion: {in: 1..1000}
  validate :error_if_not_in_stock

  def in_stock?
    product.stock >= amount
  end
  
  def price
    product.price * amount
  end

  private
  def error_if_not_in_stock
    if product.present?
      errors.add :product, :not_in_stock unless in_stock?
    end
  end
end

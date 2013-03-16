class Buy < ActiveRecord::Base
  before_save :update_product_count
  after_create :update_buyer
  after_create :update_products

  belongs_to :buyer, class_name: 'User'
  has_many :consists_of_products, class_name: 'BuyEntry'
  has_many :products, through: :consists_of_products
  attr_accessible :consists_of_products, :buyer

  validates :buyer, presence: true
  validates :consists_of_products, length: {minimum: 1}
  validate :enough_products_in_stock

  def price
    return super unless product_count_changed?
    consists_of_products.inject(0){|s, e| s + e.amount * e.product.price}
  end
  def product_count
    consists_of_products.count
  end
  def self.latest(limit=20)
    with_buyer_and_products.in_create_order.limit(limit)
  end
  def self.in_create_order
    order('buys.created_at DESC')
  end
  protected
  def self.with_buyer_and_products
    eager_load{[buyer, consists_of_products.product]}
  end
  private
  def enough_products_in_stock
    consists_of_products.each do |entry|
      add_not_in_stock_error entry.product unless entry.in_stock?
    end
  end

  def add_not_in_stock_error(product)
    error_msg = I18n.t('active_record.errors.buy.products.out_of_stock',
                           :count => product.stock)
    errors.add product.name.to_sym, error_msg
  end

  def product_count_changed?
    last_product_count != consists_of_products.count
  end

  #ActiveRecord callbacks
  def update_product_count
    self.last_product_count = consists_of_products.count if product_count_changed? 
  end

  def update_buyer
    buyer.buy_count += product_count
    buyer.balance -= price
    buyer.time_of_last_buy = DateTime.now
    buyer.save
  end

  def update_products
    consists_of_products.each do |entry|
      return false unless update_buy_entry entry
    end
  end

  def update_buy_entry(buy_entry) 
    buy_entry.product.consists_of_materials.each do |entry|
      entry.material.stock -= buy_entry.amount * entry.amount
      return false unless entry.material.save
    end
  end
end

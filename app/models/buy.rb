class Buy < ActiveRecord::Base
  before_save :update_product_count
  after_create :update_buyer
  after_create :update_products

  belongs_to :buyer, class_name: 'User'
  has_many :consists_of_products, class_name: 'BuyEntry'
  has_many :products, through: :consists_of_products
  accepts_nested_attributes_for :consists_of_products

  validates :buyer_id, presence: true
  validates :consists_of_products, length: {minimum: 1}
  validate :enough_products_in_stock

  scope :with_buyer_and_products, lambda{
    joins(:buyer, consists_of_products: :product).includes(:buyer, consists_of_products: :product)
  }
  scope :in_create_order, lambda{order('buys.created_at DESC')}
  scope :latest, lambda{|limit=20| with_buyer_and_products.in_create_order.limit(limit)}

  scope :with_buyer, ->(user){where(buyer_id: user)}
  scope :with_product, ->(product){includes(:consists_of_products).where(buy_entries: {product_id: product})}

  def price
    return super unless product_count_changed?
    consists_of_products.inject(0){|s, e| s + e.amount * e.product.price}
  end
  def product_count
    consists_of_products.length
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
    last_product_count != consists_of_products.length
  end

  #ActiveRecord callbacks
  def update_product_count
    self.last_product_count = consists_of_products.count if product_count_changed?
  end

  def update_buyer
    buyer.buy_count += consists_of_products.inject(0) {|s, e| s + e.amount}
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
    buy_entry.product.buy buy_entry.amount
  end
end

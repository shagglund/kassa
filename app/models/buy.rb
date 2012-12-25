class Buy < ActiveRecord::Base
  belongs_to :buyer, class_name: 'User'
  has_many :products, class_name: 'BuyEntry'
  accepts_nested_attributes_for :products
  attr_accessible :products_attributes, :buyer_id

  validates_presence_of :buyer_id, :products
  validate :products_in_stock

  def self.latest(offset=0, limit=20)
    eager_load{[buyer, products.product]}.order('buys.created_at DESC').offset(offset).limit(limit).all
  end

  def buyer_username
    return I18n.t('buys.select_buyer') if buyer.nil? or buyer.username.blank?
    buyer.username
  end

  def products_str
    products.collect {|entry| "#{entry.amount} #{entry.product.name}"} .join(', ')
  end

  def product_count
    products.count(:amount)
  end

  def products_in_stock
    products.each do |entry|
      if entry.product.stock < entry.amount
        error_msg = I18n.t('active_record.errors.buy.products.out_of_stock',
                           :count => entry.product.stock)
        errors.add entry.product.name.to_sym, error_msg
      end
    end
  end
end

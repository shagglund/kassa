class Buy < ActiveRecord::Base
  belongs_to :buyer, class_name: 'User'
  has_many :buy_entries
  accepts_nested_attributes_for :buy_entries
  attr_accessible :buy_entries_attributes, :buyer_id
  validates_presence_of :buyer_id
  validates :price, presence: true
  validate :products_in_stock

  def buyer_username
    return I18n.t('buys.select_buyer') if buyer.nil? or buyer.username.blank?
    buyer.username
  end

  def products_str
    buy_entries.collect {|entry| "#{entry.amount} #{entry.product.name}"} .join(', ')
  end
  def as_buy_notice
    product_text =
    I18n.t('buys.buy_notice', :buyer => buyer.username, :entries => product_text.join(','), :time => created_at)
  end

  def as_json(options)
    super(options.merge(:include => :buyer, :methods => :products_str))
  end
  def product_count
    buy_entries.count(:amount)
  end

  def products_in_stock
    entries_not_in_stock = buy_entries.select {|entry| entry.product.stock < entry.amount}
    entries_not_in_stock.size == 0
  end
end

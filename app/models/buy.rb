class Buy < ActiveRecord::Base
  belongs_to :buyer, :class_name => 'User'
  has_many :buy_entries
  accepts_nested_attributes_for :buy_entries
  attr_accessible :buy_entries_attributes, :buyer_id
  validates_presence_of :buyer_id

  def buyer_username
    return "" if buyer.nil? or buyer.username.blank?
    buyer.username
  end

  def as_buy_notice
    product_text = buy_entries.collect{|entry| I18n.t('buys.bought_entry', :amount => entry.amount, :product => entry.product.name)}
    I18n.t('buys.buy_notice', :buyer => buyer.username, :entries => product_text.join(','), :time => created_at)
  end
end

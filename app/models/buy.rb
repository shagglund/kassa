class Buy < ActiveRecord::Base
  belongs_to :buyer, :class_name => 'User'
  has_many :buy_entries
  accepts_nested_attributes_for :buy_entries
  validates_presence_of :buyer_id

  def buyer_username
    return "" if buyer.nil? or buyer.username.blank?
    buyer.username
  end
end

class Buy < ActiveRecord::Base
  belongs_to :buyer, :class_name => 'User'
  has_many :buy_entries

  validates_presence_of :buyer_id
end

class Material < ActiveRecord::Base
  attr_accessible :alcohol_per_cent, :name, :price, :stock, :unit

  has_many :product_entries

  validates :name, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :alcohol_per_cent, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :unit, presence: true
end

class Material < ActiveRecord::Base
  audited

  attr_accessible :name, :price, :stock, :unit , :action_by

  has_many :product_entries

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :unit, presence: true
end

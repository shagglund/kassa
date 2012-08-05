class Product < ActiveRecord::Base
  attr_accessible :description, :name, :unit

  has_many :product_entries

  validates_associated :product_entries
  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true

  def stock
    tmp = -1
    product_entries.each do |entry|
      val = entry.material.stock / entry.amount
      tmp = val if tmp > val or tmp == -1
    end
    tmp
  end
end

class Product < ActiveRecord::Base
  default_scope eager_load{product_entries.material}

  attr_accessible :description, :name, :unit, :product_entries_attributes

  has_many :product_entries
  accepts_nested_attributes_for :product_entries
  validates_associated :product_entries

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true, unit: true

  scope :sale_listable,
            where{product_entries.materials.stock * product_entries.amount > 0}.
            select([:id, :name, :product_entries => [:amount, :material => [:stock, :price]]])

  def stock
    product_entries.min_by {|entry| entry.stock} .stock
  end

  def price
    product_entries.sum {|entry| entry.material.price * entry.amount }
  end
end

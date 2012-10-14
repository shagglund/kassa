class Product < ActiveRecord::Base
  audited

  attr_accessible :description, :name, :unit, :materials_attributes

  has_many :materials, :class_name => 'ProductEntry'
  accepts_nested_attributes_for :materials
  validates_associated :materials

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true, unit: true

  scope :sale_list,
            where{materials.materials.stock * materials.amount > 0}.
            select([:id, :name, :materials => [:amount, :material => [:stock, :price]]])

  def stock
    materials.min_by {|entry| entry.stock} .stock
  end

  def price
    price = 0
    materials.each do |entry|
      price += entry.material.price * entry.amount
    end
    price
  end

  def as_json(options)
    super(options.merge(:methods => [:stock, :price]))
  end
end

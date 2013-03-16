class Product < ActiveRecord::Base
  @@groups = [:can, :drink, :shot, :food, :non_alcoholic]
  @@units = [:piece, :ml, :cl, :dl, :litre]
  cattr_reader :groups, :units

  attr_accessible :description, :name, :unit, :group, :consists_of_materials_attributes

  has_many :consists_of_materials, :class_name => 'ProductEntry'
  has_many :materials, through: :consists_of_materials

  accepts_nested_attributes_for :consists_of_materials, :allow_destroy => true
  validates_associated :consists_of_materials

  validates :name, presence: true, uniqueness: true
  validates :unit, :inclusion => {:in => @@units}
  validates :group, :inclusion => {:in => @@groups}
  validates :consists_of_materials, length: {minimum: 1}
 
  def self.in_stock
    sub = Product.joins{consists_of_materials.material}.where{consists_of_materials.amount > material.stock}
    where{id.not_in(sub)}
  end

  def stock
    material_least_in_stock.stock
  end
  
  def material_least_in_stock
    consists_of_materials.min_by {|entry| entry.stock}
  end

  def price
    consists_of_materials.inject(0.0) {|price, entry| price + entry.price }
  end
end

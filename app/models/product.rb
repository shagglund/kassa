class Product < ActiveRecord::Base
  @@groups = %w(can drink shot food non_alcoholic )
  @@units = %w(piece ml cl dl litre)
  cattr_reader :groups, :units
  audited

  attr_accessible :description, :name, :unit, :group, :materials_attributes

  has_many :materials, :class_name => 'ProductEntry'
  accepts_nested_attributes_for :materials, :allow_destroy => true
  validates_associated :materials
  validates_presence_of :materials

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true, :inclusion => {:in => @@units}
  validates :group, presence: true, :inclusion => {:in => @@groups}

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
end

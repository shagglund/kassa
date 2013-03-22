class Product < ActiveRecord::Base
  @@groups = %w(beer long_drink cider drink shot other).freeze
  cattr_reader :groups


  has_many :consists_of_materials, :class_name => 'ProductEntry'
  has_many :materials, through: :consists_of_materials

  accepts_nested_attributes_for :consists_of_materials, :allow_destroy => true

  validates :name, presence: true, uniqueness: true
  validates :group, :inclusion => {:in => @@groups}
  validates :consists_of_materials, length: {minimum: 1}
 
  def self.localized_groups
    as_hash_with_internationalization :group, groups
  end
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
  
  private
  def self.as_hash_with_internationalization(type, values)
    hash = {}
    values.each do |value|
      hash[value] = I18n.t("activerecord.attributes.product.#{type}s.#{value}")
    end
    hash
  end
end

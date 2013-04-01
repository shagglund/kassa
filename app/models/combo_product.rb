class ComboProduct < Product
  @@groups = %w(beer long_drink cider shot other drink)
  cattr_reader :groups

  has_many :consists_of_basic_products, :class_name => 'ProductEntry'
  has_many :basic_products, through: :consists_of_basic_products

  accepts_nested_attributes_for :consists_of_basic_products, :allow_destroy => true

  validates :name, presence: true, uniqueness: true
  validates :group, inclusion: {in: groups}
  validates :consists_of_basic_products, length: {minimum: 1}

  def self.localized_groups
    as_hash_with_internationalization "group", groups
  end
 
  def self.in_stock
    sub = joins{consists_of_basic_products.basic_product}.where{consists_of_basic_products.amount > basic_product.stock}
    where{id.not_in(sub)}
  end

  def buy(amount)
    consists_of_basic_products.each do |entry|
      entry.basic_product.stock -= amount * entry.amount
      return false unless entry.basic_product.save
    end
  end

  def stock
    product_least_in_stock.stock
  end
  
  def product_least_in_stock
    consists_of_basic_products.min_by {|entry| entry.stock}
  end

  def price
    consists_of_basic_products.inject(0.0) {|price, entry| price + entry.price }
  end
end

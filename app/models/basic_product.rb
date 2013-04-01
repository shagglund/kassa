class BasicProduct < Product
  @@units = %w(piece ml cl dl litre)
  @@groups = %w(beer long_drink cider shot other)
  cattr_reader :units, :groups

  validates :price, numericality: {only_integer: false}, inclusion: {in: 0..99}
  validates :stock, numericality: {only_integer: true}, inclusion: {in: 0..9999}
  validates :group, inclusion: {in: groups}
  validates :unit, inclusion: {in: @@units}

  def self.localized_groups
    as_hash_with_internationalization "group", groups
  end

  def self.localized_units
    as_hash_with_internationalization "unit", units
  end

  def buy(amount)
    self.stock -= amount
    self.save
  end
end

class BasicProduct < Product
  @@units = %w(piece ml cl dl litre)
  cattr_reader :units

  validates :price, numericality: {only_integer: false}, inclusion: {in: 0..99}
  validates :stock, numericality: {only_integer: true}, inclusion: {in: 0..9999}
  validates :unit, inclusion: {in: @@units}

  def self.localized_units
    as_hash_with_internationalization "unit", units
  end

  def buy(amount)
    self.stock -= amount
    self.save
  end
end

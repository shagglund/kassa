class Material < ActiveRecord::Base
  @@groups = %w(beer long_drink cider shot other).freeze
  @@units = %w(piece ml cl dl litre).freeze
  cattr_reader :groups, :units

  has_many :product_entries
  has_many :products, through: :product_entries

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: {only_integer: false}, inclusion: {in: 0..99}
  validates :stock, numericality: {only_integer: true}, inclusion: {in: 0..9999}
  validates :unit, inclusion: {in: @@units}
  validates :group, inclusion: {in: @@groups}

  def self.localized_units
    as_hash_with_internationalization "unit", units
  end
  def self.localized_groups
    as_hash_with_internationalization "group", groups
  end

  private
  def self.as_hash_with_internationalization(type, values)
    hash = {}
    values.each do |value|
      hash[value] = I18n.t("activerecord.attributes.material.#{type}s.#{value}")
    end
    hash
  end
end

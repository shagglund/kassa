class Material < ActiveRecord::Base
  @@groups = %w(can shot food non_alcoholic )
  @@units = %w(piece ml cl dl litre)
  cattr_reader :groups, :units
  audited

  attr_accessible :name, :price, :stock, :unit, :group , :action_by

  has_many :product_entries

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :unit, presence: true, :inclusion => {:in => @@units}
  validates :group, presence: true, :inclusion => {:in => @@groups}
end

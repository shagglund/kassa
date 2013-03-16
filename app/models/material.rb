class Material < ActiveRecord::Base
  @@groups = [:can, :shot, :food, :other]
  @@units = [:piece, :ml, :cl, :dl, :litre]
  cattr_reader :groups, :units

  attr_accessible :name, :price, :stock, :unit, :group

  has_many :product_entries
  has_many :products, through: :product_entries

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: {only_integer: false}, inclusion: {in: 0..99}
  validates :stock, numericality: {only_integer: true}, inclusion: {in: 0..9999}
  validates :unit, inclusion: {in: @@units}
  validates :group, inclusion: {in: @@groups}
end

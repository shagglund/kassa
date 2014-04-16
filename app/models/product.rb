class Product < ActiveRecord::Base
  has_many :buy_entries
  has_many :buys, through: :buy_entries

  AT_LEAST_ONE_NON_DIGIT_AND_NO_SLASHES = /\A\d*[^\d\\\/]+\d*\z/
  validates :name, presence: true, uniqueness: true, format: {with: AT_LEAST_ONE_NON_DIGIT_AND_NO_SLASHES}
  validates :price, numericality: {only_integer: false}, inclusion: {in: 0..99}

  scope :with_id_or_name, ->(id){id.to_s =~ /\A\d+\z/ ? where(id: id) : where(name: id)}

  #Placeholder methods for now, to be replaced with a real column
  def available; stock > 0; end
  def available=(avl); self.stock = (avl ? 1 : 0); end
end

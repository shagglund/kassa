class User < ActiveRecord::Base
  devise :recoverable, :lockable, :rememberable,
         :validatable, :trackable, :database_authenticatable

  has_many :buys, foreign_key: 'buyer_id'

  validates :username, presence: true, length: {in: 3..16}, uniqueness: true
  validates :balance, numericality: { only_integer: false}, inclusion: {in: -1000..1000}
  validates :buy_count, numericality: { only_integer: true}, inclusion: {in:0..100000} 
end

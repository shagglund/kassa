class User < ActiveRecord::Base
  devise :recoverable, :lockable, :rememberable,
         :validatable, :trackable, :database_authenticatable

  audited

  attr_accessible :username, :balance, :email, :password, :password_confirmation

  validates :username, presence: true, length: {in: 3..16}, uniqueness: {case_sensitive: false}

  has_many :buys

  scope :buyer_list, lambda {select(:id, :username, :buy_count, :balance)}
end

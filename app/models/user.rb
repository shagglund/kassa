class User < ActiveRecord::Base
  devise :recoverable, :lockable, :registerable, :rememberable,
         :validatable, :trackable, :recoverable, :database_authenticatable

  attr_accessible :username, :saldo, :email, :password, :password_confirmation

  validates :username, presence: true
end

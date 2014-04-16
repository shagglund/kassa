class User < ActiveRecord::Base
  MIN_BALANCE = -1000
  MAX_BALANCE = 1000
  MIN_BUY_COUNT = 0
  MAX_BUY_COUNT = 100000
  AT_LEAST_ONE_NON_DIGIT_AND_NO_SLASHES = /\A\d*[^\d\\\/]+\d*\z/

  devise :recoverable, :rememberable, :validatable, :trackable, :database_authenticatable

  has_many :buys, foreign_key: 'buyer_id'
  has_many :balance_changes, as: :trackable

  validates :username, presence: true, length: {in: 2..16}, uniqueness: true, format: {with: AT_LEAST_ONE_NON_DIGIT_AND_NO_SLASHES}
  validates :balance, numericality: { only_integer: false}, inclusion: {in: MIN_BALANCE..MAX_BALANCE}
  validates :buy_count, numericality: { only_integer: true}, inclusion: {in: MIN_BUY_COUNT..MAX_BUY_COUNT}

  scope :with_id_or_username, ->(id){id.to_s =~ /\A\d+\z/ ? where(id: id) : where(username: id)}

  def change_balance(new_balance, change_note, doer)
    return if balance == new_balance
    transaction(requires_new: true) do
      balance_change = balance_changes.create(doer: doer, change: {from: balance, to: new_balance}, change_note: change_note)
      if balance_change.new_record?
        self.errors.add :balance, balance_change.errors
      else
        self.balance = new_balance
        return self.save || raise(ActiveRecord::Rollback.new)
      end
    end
    false
  end
end

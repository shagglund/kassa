class BalanceChange < Change
  validates :old_balance, numericality: true
  validates :new_balance, numericality: true
  validate :old_balance_is_not_equal_to_new_balance

  change_accessor :old_balance, 'from'
  change_accessor :new_balance, 'to'

  def balance_change; new_balance.to_f - old_balance.to_f; end

  def old_balance_is_not_equal_to_new_balance
    if old_balance == new_balance
      errors.add :new_balance, :equal
      errors.add :old_balance, :equal
    end
  end
end
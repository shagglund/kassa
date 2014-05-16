class BalanceChange < Change
  validates :old_balance, numericality: true
  validates :new_balance, numericality: true
  validate :old_balance_is_not_equal_to_new_balance

  def old_balance; change['from']; end

  def old_balance=(old_balance)
    self.change ||= {}
    self.change_will_change! unless self.change['from'] == old_balance
    self.change['from'] = old_balance
  end

  def new_balance; change['to']; end

  def new_balance=(new_balance)
    self.change ||= {}
    self.change_will_change! unless self.change['to'] == new_balance
    self.change['to'] = new_balance
  end

  def balance_change; new_balance.to_f - old_balance.to_f; end

  def old_balance_is_not_equal_to_new_balance
    if old_balance == new_balance
      errors.add :new_balance, :equal
      errors.add :old_balance, :equal
    end
  end
end
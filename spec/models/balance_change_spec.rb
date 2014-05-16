require 'spec_helper'

describe BalanceChange do
  let(:new_balance) {100.21}
  let(:old_balance) {200.12}
  subject {described_class.new old_balance: old_balance, new_balance: new_balance}

  it {should validate_numericality_of :old_balance}
  it {should validate_numericality_of :new_balance}

  describe '#new_balance' do
    it "returns the new balance" do
      expect(subject.new_balance).to eq(new_balance)
    end
  end
  describe '#old_balance' do
    it "returns the new balance" do
      expect(subject.old_balance).to eq(old_balance)
    end
  end

  describe '#balance_change' do
    def new_balance_change(old_balance, new_balance)
      BalanceChange.new old_balance: old_balance, new_balance: new_balance
    end
    it "should return correct difference when both are negative" do
      change = new_balance_change(-100.00, -80.00)
      expect(change.balance_change).to eq(20.00)
    end
    it "should return correct difference when only old_balance is negative" do
      change = new_balance_change(-100.00, 80.00)
      expect(change.balance_change).to eq(180.00)
    end
    it "should return correct difference when only new_balance is negative" do
      change = new_balance_change(100.00, -80.00)
      expect(change.balance_change).to eq(-180.00)
    end
    it "should return correct difference when both are positive" do
      change = new_balance_change(100.00, 80.00)
      expect(change.balance_change).to eq(-20.00)
    end
  end
end
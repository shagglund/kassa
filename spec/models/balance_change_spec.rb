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

  describe '#new_balance=' do
    it "changes the balance" do
      subject.new_balance= new_balance + 1
      expect(subject.new_balance).to eq(new_balance + 1)
    end

    it "marks the change-column as changed" do
      subject.new_balance= new_balance + 1
      expect(subject.change_changed?).to be_true
    end

    it "doesn't mark the change-column as changed if new value == old value" do
      subject.send :reset_changes
      subject.new_balance= new_balance
      expect(subject.change_changed?).to be_false
    end
  end

  describe '#old_balance' do
    it "returns the new balance" do
      expect(subject.old_balance).to eq(old_balance)
    end
  end

  describe '#old_balance=' do
    it "changes the balance" do
      subject.old_balance= old_balance + 1
      expect(subject.old_balance).to eq(old_balance + 1)
    end

    it "marks the change-column as changed" do
      subject.old_balance= old_balance + 1
      expect(subject.change_changed?).to be_true
    end

    it "doesn't mark the change-column as changed if new value == old value" do
      subject.send :reset_changes
      subject.old_balance= old_balance
      expect(subject.change_changed?).to be_false
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
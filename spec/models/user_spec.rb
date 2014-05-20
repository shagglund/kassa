require 'spec_helper'

describe User do
  subject{FactoryGirl.build(:user)}

  it {should validate_presence_of :username}
  it {should validate_uniqueness_of(:username)}
  it {should ensure_length_of(:username).is_at_least(2).is_at_most(16)}

  it {should validate_presence_of :email}

  it {should validate_numericality_of :balance}
  it {should ensure_inclusion_of(:balance).in_range(-1000..1000)}

  it {should validate_numericality_of(:buy_count)}
  it {should ensure_inclusion_of(:buy_count).in_range(0..100000)}

  it {should validate_presence_of :password}

  it {should have_many :buys}

  let(:user){FactoryGirl.create(:user)}
  let(:new_balance){user.balance + 100}
  let(:change_note){'Testing changes to user balance'}
  let(:doer){FactoryGirl.create(:user)}

  describe "#change_balance" do
    it "should not update the balance if old balance == new balance" do
      expect{
        expect(user.change_balance(user.balance, change_note, doer)).to be_false
      }.to_not change(BalanceChange, :count)
    end

    context "creating BalanceChange-record" do
      it "should add a new record on updated balance" do
        expect{
          user.change_balance new_balance, change_note, doer
        }.to change(BalanceChange, :count).by(1)
      end

      it "should remove the added record if the user could not be saved" do
        user.stub(:save).and_return false
        expect{
          user.change_balance new_balance, change_note, doer
        }.to_not change(BalanceChange, :count)
      end
    end

    context "valid change" do
      it "should update the users balance" do
        expect{
          user.change_balance new_balance, change_note, doer
        }.to change(user, :balance).from(user.balance).to(new_balance)
      end
      it "should not save the user" do
        expect(user).to receive(:save).and_return true
        user.change_balance new_balance, change_note, doer
      end
      it "should return false" do
        expect(user.change_balance new_balance, change_note, doer).to be_true
      end
    end

    context "invalid change note" do
      it "should not update the users balance" do
        expect{
          user.change_balance new_balance, nil, doer
        }.to_not change(user, :balance)
      end
      it "should not save the user" do
        expect(user).to_not receive(:save)
        user.change_balance new_balance, nil, doer
      end
      it "should return false" do
        expect(user.change_balance new_balance, nil, doer).to be_false
      end
    end

    context "invalid balance" do
      let(:invalid_balance){User::MIN_BALANCE - 1}
      it "should not update the users balance" do
        expect{
          user.change_balance invalid_balance, change_note, doer
          expect(user).to have(1).error_on(:balance)
        }.to_not change(BalanceChange, :count)
      end
      it "should not save the user" do
        old_balance = user.balance
        user.change_balance invalid_balance, change_note, doer
        expect(user).to be_invalid
        expect(user.balance_change).to eq([old_balance, invalid_balance])
      end
      it "should return false" do
        expect(user.change_balance invalid_balance, change_note, doer).to be_false
      end
    end
  end

  describe "#active=" do
    it "should set the active flag on true" do
      subject.active = true
      expect(subject.bit_flags & User::FLAG_ACTIVE).to eq(User::FLAG_ACTIVE)
    end

    it "should remove the active flag on false" do
      subject.active = false
      expect(subject.bit_flags & User::FLAG_ACTIVE).to eq(0)
    end
  end

  describe "#active/active?" do
    it "should return true if the user is set active" do
      subject.bit_flags |= User::FLAG_ACTIVE
      expect(subject.active).to be_true
      expect(subject.active?).to be_true
    end

    it "should return false if the user is set inactive" do
      subject.bit_flags &= User::FLAG_ACTIVE
      expect(subject.active).to be_false
      expect(subject.active?).to be_false
    end
  end
end

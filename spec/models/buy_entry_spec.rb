require 'spec_helper'

describe BuyEntry do
  it "should be linked to a buy" do
    entry = FactoryGirl.build(:buy_entry, :buy => nil)
    entry.should_not be_valid
    entry.should have(1).error_on(:buy_id)
  end

  it "should be linked to a product" do
    entry = FactoryGirl.build(:buy_entry, :product => nil)
    entry.should_not be_valid
    entry.should have(1).error_on(:product_id)
  end

  context "#amount" do
    it "should be positive" do
      entry = FactoryGirl.build(:buy_entry, :amount => -1)
      entry.should_not be_valid
      entry.should have(1).error_on(:amount)
      entry.amount = 0
      entry.should_not be_valid
      entry.should have(1).error_on(:amount)
    end

    it "can't be null" do
      entry = FactoryGirl.build(:buy_entry, :amount => nil)
      entry.should_not be_valid
      entry.should have(2).errors_on(:amount)
    end
  end
end

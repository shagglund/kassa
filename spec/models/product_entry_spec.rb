require 'spec_helper'

describe ProductEntry do
  it "should require a product" do
    product_entry = FactoryGirl.build(:product_entry, :product => nil)
    product_entry.should_not be_valid
    product_entry.should have(1).error_on(:product_id)
  end

  it "should require a material" do
    product_entry = FactoryGirl.build(:product_entry, :material => nil)
    product_entry.should_not be_valid
    product_entry.should have(1).error_on(:material_id)
  end

  it "should have a positive, non-zero amount" do
    product_entry = FactoryGirl.build(:product_entry, :amount => 0)
    product_entry.should_not be_valid
    product_entry.should have(1).error_on(:amount)
    product_entry.amount = -1
    product_entry.should_not be_valid
    product_entry.should have(1).error_on(:amount)
    product_entry.amount = nil
    product_entry.should_not be_valid
    product_entry.should have(2).errors_on(:amount)
  end
end

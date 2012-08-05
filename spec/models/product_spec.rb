require 'spec_helper'

describe Product do
  it "should have a name" do
    product = FactoryGirl.build(:product, :name => nil)
    product.should_not be_valid
    product.should have(1).error_on(:name)
  end
  it "should have a unit" do
    product = FactoryGirl.build(:product, :unit => nil)
    product.should_not be_valid
    product.should have(1).error_on(:unit)
  end
end

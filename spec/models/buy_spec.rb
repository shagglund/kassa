require 'spec_helper'

describe Buy do
  it "should have a buyer" do
    buy = FactoryGirl.build(:buy, :buyer => nil)
    buy.should_not be_valid
    buy.should have(1).error_on(:buyer_id)
    buy.buyer = FactoryGirl.create :user
    buy.should be_valid
  end

  it "should have at least 1 product to be bought" do
    buy = FactoryGirl.build(:buy, :products => nil)
    buy.should_not be_valid
    buy.should have(1).error_on(:products)
    buy.products << FactoryGirl.create(:product)
    buy.should be_valid
  end

  it "should have a price calculated from the products after create" do
    product = FactoryGirl.create :product
    buy = FactoryGirl.create(:buy, :products => [product])
    buy.price.should_not be_nil
    buy.price.should == product.price
  end
end

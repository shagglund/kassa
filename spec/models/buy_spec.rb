require 'spec_helper'

describe Buy do
  it "should have a buyer" do
    buy = FactoryGirl.build(:buy, :buyer => nil)
    buy.should_not be_valid
    buy.should have(1).error_on(:buyer_id)
  end
end

require 'spec_helper'

describe ProductEntry do
  it {should validate_numericality_of :amount}
  it {should ensure_inclusion_of(:amount).in_range(1..999)}

  it {should belong_to :material}
  it {should validate_presence_of :material}
  it {should belong_to :product}

  subject { FactoryGirl.build :product_entry }

  context "#stock" do
    it "should be calculated from material and amount" do
      subject.material.stock = 2
      subject.amount = 1
      subject.stock.should == 2
    end
    it "should return zero if there isn't enough material" do
      subject.material.stock = 1
      subject.amount = 2
      subject.stock.should == 0
    end
  end

  context "#price" do
    it "should be calculated from material and amount" do
      subject.material.price = 2
      subject.amount = 2
      subject.price.should == 4
    end
  end
end

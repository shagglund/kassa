require 'spec_helper'

describe ProductEntry do
  it {should validate_numericality_of :amount}
  it {should ensure_inclusion_of(:amount).in_range(1..999)}

  it {should belong_to :basic_product}
  it {should validate_presence_of :basic_product}
  it {should belong_to :combo_product}

  subject { FactoryGirl.build :product_entry }

  context "#stock" do
    it "should be calculated from basic_product and amount" do
      subject.basic_product.stock = 2
      subject.amount = 1
      subject.stock.should == 2
    end
    it "should return zero if there isn't enough basic_product" do
      subject.basic_product.stock = 1
      subject.amount = 2
      subject.stock.should == 0
    end
  end

  context "#price" do
    it "should be calculated from basic_product and amount" do
      subject.basic_product.price = 2
      subject.amount = 2
      subject.price.should == 4
    end
  end
end

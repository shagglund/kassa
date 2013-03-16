require 'spec_helper'

describe BuyEntry do
  it {should belong_to :product}
  it {should validate_presence_of :product}
  it {should allow_mass_assignment_of :product}

  it {should belong_to :buy}
  it {should validate_presence_of :buy}
  it {should allow_mass_assignment_of :buy}

  it {should validate_numericality_of(:amount).only_integer}
  it {should ensure_inclusion_of(:amount).in_range(1..1000)}
  it {should allow_mass_assignment_of :amount}

  subject { FactoryGirl.build :buy_entry }

  context "#amount" do
    it "should add an error to product if not enough in stock" do
      zero_stock_on_first
      subject.should_not be_valid
      subject.should have(1).error_on(:product)
    end
    def zero_stock_on_first
      subject.product.consists_of_materials.first.material.stock = 0
    end
  end
end

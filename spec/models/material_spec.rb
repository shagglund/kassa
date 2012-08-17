require 'spec_helper'

describe Material do
  context "#name" do
    it "should be required" do
      material = FactoryGirl.build(:material, :name=>nil)
      material.should_not be_valid
      material.should have(1).error_on(:name)
    end
  end
  context "#price" do
    it "can't be null" do
      material = FactoryGirl.build(:material, :price=>nil)
      material.should_not be_valid
      material.should have(2).errors_on(:price)
    end
    it "should be greater than or equal to 0" do
      material = FactoryGirl.build(:material, :price=>-1)
      material.should_not be_valid
      material.should have(1).errors_on(:price)
    end

    it "can be decimal" do
      material = FactoryGirl.build(:material, :price=> 0.5)
      material.should be_valid
    end
  end

  context "#stock" do
    it "should be greater than or equal to 0" do
      material = FactoryGirl.build(:material, :stock=>-1)
      material.should_not be_valid
      material.should have(1).errors_on(:stock)
    end

    it "should be an integer" do
      material = FactoryGirl.build(:material, :stock=>1.5)
      material.should_not be_valid
      material.should have(1).errors_on(:stock)
    end

    it "can't be null" do
      material = FactoryGirl.build(:material, :stock=>nil)
      material.should_not be_valid
      material.should have(2).errors_on(:stock)
    end
  end
  context "#unit" do

    it "should require a unit" do
      material = FactoryGirl.build(:material, :unit=>nil)
      material.should_not be_valid
      material.should have(1).error_on(:unit)
    end

  end
end

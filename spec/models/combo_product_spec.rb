require 'spec_helper'
require 'shared_examples_for_products'
describe ComboProduct do
  it {should have_many :consists_of_basic_products}

  it {should have_many(:basic_products).through :consists_of_basic_products}

  include_examples 'localized group', %w(drink beer long_drink cider shot other)

  subject{FactoryGirl.build :combo_product}
  context "#price" do
    it "should be calculated from all linked products" do
      price = subject.consists_of_basic_products.inject(0){|p,e| p+e.price}
      subject.price.should eq price
    end
  end

  context "#stock" do
    it "should be calculated from all linked products" do
      stock = subject.consists_of_basic_products.min_by{|m| m.stock}.stock
      subject.stock.should eq stock
    end
  end

  context "#product_least_in_stock" do
    it "should return the limiting product" do
      mat = subject.consists_of_basic_products.min_by{|m| m.stock}
      subject.product_least_in_stock.should eq mat
    end
  end
  context ".in_stock scope" do
    it "should return products where stock > 0" do
      subj = FactoryGirl.create :combo_product
      m = subj.basic_products.first
      m.stock = 0
      m.save
      ComboProduct.in_stock.all.should_not include(subj)
    end
  end
end

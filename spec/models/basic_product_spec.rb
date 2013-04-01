require 'spec_helper'
require 'shared_examples_for_products'

describe BasicProduct do
  it {should validate_presence_of :name }
  it "should validate uniqueness of name" do
    FactoryGirl.create :basic_product
    should validate_uniqueness_of :name
  end

  it {should validate_numericality_of :price}
  it {should ensure_inclusion_of(:price).in_range(0..99)}

  it {should validate_numericality_of(:stock).only_integer}
  it {should ensure_inclusion_of(:stock).in_range(0..9999)}

  include_examples 'localized group', %w(beer long_drink cider shot other)

  it {should ensure_inclusion_of(:unit).in_array %w(piece ml cl dl litre)}
  it "should create a hash with <unit>:<internationalized unit>" do
    BasicProduct.localized_units.should_not be_empty
    BasicProduct.localized_units.each do |k,v|
      expect{
        v.should eq I18n.translate!("activerecord.attributes.basic_product.units.#{k}", raise: true)
      }.to_not raise_error
    end
  end

end

require 'spec_helper'
require 'shared_examples_for_products'

describe Product do
  it 'should validate uniqueness of name' do
    FactoryGirl.build(:product).save(validate: false)
    should validate_uniqueness_of :name
  end
  it {should validate_presence_of :name}

  include_examples 'localized group'
end

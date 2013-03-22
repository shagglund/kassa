require 'spec_helper'

describe Material do
  it {should validate_presence_of :name }
  it "should validate uniqueness of name" do
    FactoryGirl.create :material
    should validate_uniqueness_of :name
  end

  it {should validate_numericality_of :price}
  it {should ensure_inclusion_of(:price).in_range(0..99)}

  it {should validate_numericality_of(:stock).only_integer}
  it {should ensure_inclusion_of(:stock).in_range(0..9999)}

  it {should ensure_inclusion_of(:unit).in_array Material.units}

  it {should ensure_inclusion_of(:group).in_array Material.groups}
  
  it {should have_many :product_entries}
  it {should have_many(:products).through :product_entries }
end

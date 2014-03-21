require 'spec_helper'

describe Product do
  it {should validate_presence_of :name }
  it {should validate_uniqueness_of :name}

  it {should validate_numericality_of :price}
  it {should ensure_inclusion_of(:price).in_range(0..99)}

  it {should have_many :buy_entries}

  it {should have_many(:buys).through(:buy_entries)}

end

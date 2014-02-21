require 'spec_helper'

describe Product do
  it {should validate_presence_of :name }
  it {should validate_uniqueness_of :name}

  it {should validate_numericality_of :price}
  it {should ensure_inclusion_of(:price).in_range(0..99)}

  it {should validate_numericality_of(:stock).only_integer}
  it {should ensure_inclusion_of(:stock).in_range(0..9999)}

  it {should ensure_inclusion_of(:unit).in_array %w(piece ml cl dl litre)}
  it {should ensure_inclusion_of(:group).in_array %w(beer long_drink cider shot other)}

end

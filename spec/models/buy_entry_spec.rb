require 'spec_helper'

describe BuyEntry do
  it {should belong_to :product}
  it {should validate_presence_of :product_id}

  it {should belong_to :buy}

  it {should validate_numericality_of(:amount).only_integer}
  it {should ensure_inclusion_of(:amount).in_range(1..1000)}
end

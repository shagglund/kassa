require 'spec_helper'

describe User do
  it {should validate_presence_of :username}
  it "should validate uniqueness of username" do
    FactoryGirl.create :user
    should validate_uniqueness_of(:username)
  end
  it {should ensure_length_of(:username).is_at_least(3).is_at_most(16)}
  it {should allow_mass_assignment_of :username}

  it {should validate_presence_of :email}
  it {should allow_mass_assignment_of :email}

  it {should validate_numericality_of :balance}
  it {should ensure_inclusion_of(:balance).in_range(-1000..1000)}
  it {should allow_mass_assignment_of :balance}

  it {should validate_numericality_of(:buy_count)}
  it {should ensure_inclusion_of(:buy_count).in_range(0..100000)}
  it {should_not allow_mass_assignment_of :buy_count}

  it {should validate_presence_of :password}
  it {should_not allow_mass_assignment_of :password}
  it {should_not allow_mass_assignment_of :password_confirmation}

  it {should have_many :buys}
end

require 'spec_helper'

describe User do
  context "#username"do
    it "can't be null" do
      user = FactoryGirl.build(:user, :username => nil)
      user.should_not be_valid
      user.should have(2).errors_on(:username)
    end

    it "must be between 3 and 16 characters long" do
      user = FactoryGirl.build(:user, :username => "a"*2)
      user.should_not be_valid
      user.should have(1).error_on(:username)
      user.username = "a"*17
      user.should_not be_valid
      user.should have(1).error_on(:username)
    end
  end

  it "should have an email" do
    user = FactoryGirl.build(:user, :email => nil)
    user.should_not be_valid
    user.should have(1).error_on(:email)
  end

  it "should have a password" do
    user = FactoryGirl.build(:user, :password => nil)
    user.should_not be_valid
    user.should have(1).error_on(:password)
  end
end

require 'spec_helper'

describe SessionsController do

  describe "GET 'current'" do
    it "returns http success" do
      get 'current'
      response.should be_success
    end
  end

end

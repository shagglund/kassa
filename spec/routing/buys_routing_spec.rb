require "spec_helper"

describe BuysController do
  describe "routing" do

    it "routes to #index" do
      get("/buys").should route_to("buys#index")
    end

    it "routes to #new" do
      get("/buys/new").should route_to("buys#new")
    end

    it "routes to #show" do
      get("/buys/1").should route_to("buys#show", :id => "1")
    end

    it "routes to #edit" do
      get("/buys/1/edit").should route_to("buys#edit", :id => "1")
    end

    it "routes to #create" do
      post("/buys").should route_to("buys#create")
    end

    it "routes to #update" do
      put("/buys/1").should route_to("buys#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/buys/1").should route_to("buys#destroy", :id => "1")
    end

  end
end

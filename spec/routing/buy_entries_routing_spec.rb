require "spec_helper"

describe BuyEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/buy_entries").should route_to("buy_entries#index")
    end

    it "routes to #new" do
      get("/buy_entries/new").should route_to("buy_entries#new")
    end

    it "routes to #show" do
      get("/buy_entries/1").should route_to("buy_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/buy_entries/1/edit").should route_to("buy_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/buy_entries").should route_to("buy_entries#create")
    end

    it "routes to #update" do
      put("/buy_entries/1").should route_to("buy_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/buy_entries/1").should route_to("buy_entries#destroy", :id => "1")
    end

  end
end

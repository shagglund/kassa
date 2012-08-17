require "spec_helper"

describe ProductEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/product_entries").should route_to("product_entries#index")
    end

    it "routes to #new" do
      get("/product_entries/new").should route_to("product_entries#new")
    end

    it "routes to #show" do
      get("/product_entries/1").should route_to("product_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/product_entries/1/edit").should route_to("product_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/product_entries").should route_to("product_entries#create")
    end

    it "routes to #update" do
      put("/product_entries/1").should route_to("product_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/product_entries/1").should route_to("product_entries#destroy", :id => "1")
    end

  end
end

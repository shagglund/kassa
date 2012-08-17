require "spec_helper"

describe MaterialsController do
  describe "routing" do

    it "routes to #index" do
      get("/materials").should route_to("materials#index")
    end

    it "routes to #new" do
      get("/materials/new").should route_to("materials#new")
    end

    it "routes to #show" do
      get("/materials/1").should route_to("materials#show", :id => "1")
    end

    it "routes to #edit" do
      get("/materials/1/edit").should route_to("materials#edit", :id => "1")
    end

    it "routes to #create" do
      post("/materials").should route_to("materials#create")
    end

    it "routes to #update" do
      put("/materials/1").should route_to("materials#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/materials/1").should route_to("materials#destroy", :id => "1")
    end

  end
end

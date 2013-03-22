require "spec_helper"
require "shared_examples_for_api_controllers"
describe MaterialsController do
  let(:resource){FactoryGirl.build :material}

  context "with an authenticated user" do
    include_examples "authenticate user"
    describe "GET index" do
      let(:resources){[resource]}
      before(:each){Material.should_receive(:all).and_return resources}
      include_examples "a valid index request"
    end
    describe "GET show" do
      include_examples "a valid show request"
    end
    describe "PUT update" do
      context "with valid data" do
        include_examples "an update with valid data"
      end
      context "with invalid data" do
        include_examples "an update with invalid data"
      end
      context "permitted attributes" do
        include_examples "setup update request before each" 
        it "should allow unit, group, name, price and stock to be set" do
          fake_params.should_receive(:permit).with(:unit, :group, :name, :price, :stock)
          put :update, format: :json, id: 1
        end
      end
    end
    describe "POST create" do
      context "with valid data" do
        include_examples "a create with valid data"
      end
      context "with invalid data" do
        include_examples "a create with invalid data"
      end
      context "permitted attributes" do
        include_examples "setup create request before each" 
        it "should allow unit, group, name, price and stock to be set" do
          fake_params.should_receive(:permit).with(:unit, :group, :name, :price, :stock)
          post :create, format: :json 
        end
      end
    end
    describe "DELETE destroy" do
      include_examples "a valid destroy request"
    end
  end
  context "with an unauthenticated user" do
    include_examples "unauthenticate user"

    context "GET index" do
      include_examples "an unauthorized index request"
    end
    context "GET show" do
      include_examples "an unauthorized show request"
    end
    context "PUT update" do
      include_examples "an unauthorized update request"
    end
    context "POST create" do
      include_examples "an unauthorized create request"
    end
    context "DELETE destroy" do
      include_examples "an unauthorized destroy request"
    end
  end
end

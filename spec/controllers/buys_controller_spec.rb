require 'spec_helper'
require 'shared_examples_for_api_controllers'
describe BuysController do
  let(:resource) {FactoryGirl.build :buy}
  context "with an authenticated user" do
    include_examples "authenticate user"
    describe "GET #index" do
      let(:resources) {[resource]}
      context "with no query params" do
        before(:each){Buy.should_receive(:latest).with(20).and_return double(all: resources)}
        include_examples "a valid index request"
      end
      context "with custom limit" do
        before(:each){ Buy.should_receive(:latest).with(50).and_return double(all: resources)}
        include_examples "a valid index request", limit: 50
      end
      context "with offset" do
        before :each do
          fake_latest = double(latest: double(all: resources))
          Buy.should_receive(:offset).with(50).and_return fake_latest
        end
        include_examples "a valid index request", offset: 50
      end
    end
    describe "#GET show" do
      include_examples "a valid show request"
    end
    describe "#POST create" do 
      context "with valid buy data" do
        include_examples "a create with valid data"
      end
      context "with invalid buy data" do
        include_examples "a create with invalid data"
      end
      context "permitted attributes" do
        include_examples "setup create request before each" 
        it "should allow buyer_id, price and products to be set" do
          fake_params.should_receive(:permit).with(:buyer_id, :price, consists_of_products_attributes: [:amount, :product_id])
          post :create, format: :json
        end
      end
    end
  end
  context "with an unauthenticated user" do
    include_examples "unauthenticate user"
    context "#GET index" do
      include_examples "an unauthorized index request"
    end
    context "#GET show" do
      include_examples "an unauthorized show request"
    end
    context "#POST create" do
      include_examples "an unauthorized create request"
    end
  end
end

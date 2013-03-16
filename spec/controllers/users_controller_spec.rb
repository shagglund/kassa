require 'spec_helper'
require 'shared_examples_for_api_controllers'
describe UsersController do
  let(:resource){FactoryGirl.build :user}
  context "with an authenticated user" do
    include_examples "authenticate user"
    describe "GET current" do
      before(:each){Kassa::CurrentUserRequest.new(self, resource).execute}
      it {should respond_with :success}
      include_examples "a single entity json response"
    end

    describe "GET index" do
      let(:resources){[resource]}
      before(:each){User.should_receive(:all).and_return resources}
      include_examples "a valid index request"
    end
    describe "GET show" do
      include_examples "a valid show request"
    end
    describe "PUT update" do
      context "as not an admin" do
        include_examples "a forbidden update"
      end
      context "as an admin" do
        include_examples "authenticate admin"
        context "and valid data" do
          include_examples "an update with valid data"
        end
        context "and invalid data" do
          include_examples "an update with invalid data"
        end
      end
    end
    describe "POST create" do
      context "without admin privilidges" do
        include_examples "a forbidden create"
      end
      context "with admin privilidges" do
        include_examples "authenticate admin"
        context "and valid data" do
          include_examples "a create with valid data"
        end
        context "and invalid data" do
          include_examples "a create with invalid data"
        end
      end
    end
  end
  context "with unauthorized user" do
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
    context "GET current" do
      before(:each){get :current, format: :json}
      include_examples "an unauthorized request"
    end
  end
end

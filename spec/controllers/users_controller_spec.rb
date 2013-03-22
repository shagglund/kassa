require 'spec_helper'
require 'shared_examples_for_api_controllers'
describe UsersController do
  let(:resource){FactoryGirl.build :user}
  context "with an authenticated user" do
    include_examples "authenticate user"
    describe "GET current" do
      before(:each) do
        controller.stub(:current_user).and_return resource
        get :current, format: :json
      end
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
      context "and valid data" do
        include_examples "an update with valid data"
      end
      context "and invalid data" do
        include_examples "an update with invalid data"
      end
      describe "permitted attributes" do
        include_examples "setup update request before each"
        let(:request_params){ {format: :json, id: 1}}
        context "as an admin" do
          before(:each){current_user.admin = true}
          it "should permit username, balance, email, admin and staff to be set" do
            fake_params.should_receive(:permit).with(:username, :email, :admin, :staff, :balance)
            put :update, request_params
          end
        end
        context "as the same user (updating own information)" do
          before(:each){controller.stub(:current_user).and_return resource}
          it "should permit username, balance, and email attributes to be set" do
            fake_params.should_receive(:permit).with(:username, :email, :balance)
            put :update, request_params
          end
        end
        context "as not an admin nor the same user" do
          it "should not permit any attributes to be set" do
            fake_params.should_receive(:permit).with()
            put :update, request_params
          end
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
        context "permitted attributes" do
          include_examples "setup create request before each"
          it "should allow username, email, admin, staff and balance to be set" do
            fake_params.should_receive(:permit).with(:username, :email, :admin, :staff, :balance)
            post :create, format: :json
          end  
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

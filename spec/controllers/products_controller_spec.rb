require 'spec_helper'
require 'shared_examples_for_api_controllers'
describe ProductsController do
  let(:resource){FactoryGirl.build :product_with_materials}
  context "with an authenticated user" do
    include_examples "authenticate user"
    
    describe "#GET index" do
      let(:resources){ [resource]}
      context "with no query params" do
        before(:each){Product.should_receive(:all).and_return resources}
        include_examples "a valid index request"
      end
      context "with in_stock" do
        let(:options){ {in_stock: true} }
        before(:each){ Product.should_receive(:in_stock).and_return double(:all => resources) if Product.respond_to? :in_stock}
        include_examples "a valid index request", in_stock: true
      end
    end
    context "#GET show" do
      include_examples "a valid show request"
    end
    context "POST create" do
      context "with valid data" do
        include_examples "a create with valid data"
      end
      context "with invalid data" do
        include_examples "a create with invalid data"
      end
    end
    context "#PUT update" do
      context "with valid data" do
        include_examples "an update with valid data"
      end
      context "with invalid data" do
        include_examples "an update with invalid data"
      end
    end
    context "#DELETE destroy" do
      include_examples "a valid destroy request"
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
    context "#PUT update" do
      include_examples "an unauthorized update request"
    end
    context "#DELETE destroy" do
      include_examples "an unauthorized destroy request"
    end
  end
end
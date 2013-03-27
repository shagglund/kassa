require 'spec_helper'
require 'shared_examples_for_api_controllers'
describe ComboProductsController do
  let(:resource){FactoryGirl.build :combo_product}
  context "with an authenticated user" do
    include_examples "authenticate user"
    
    describe "#GET index" do
      let(:resources){ [resource]}
      context "with no query params" do
        before(:each){ComboProduct.should_receive(:all).and_return resources}
        include_examples "a valid index request"
      end
      context "with in_stock" do
        let(:options){ {in_stock: true} }
        before(:each){ ComboProduct.should_receive(:in_stock).and_return double(:all => resources) if ComboProduct.respond_to? :in_stock}
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
      context "permitted attributes" do
        include_examples "setup create request before each" 
        it "should allow name, description, group and basic products to be set" do
          fake_params.should_receive(:permit).with(:name, :description, :group, consists_of_basic_products_attributes: [:id, :amount, :basic_product_id, :_destroy])
          post :create, format: :json
        end
      end
    end
    context "#PUT update" do
      context "with valid data" do
        include_examples "an update with valid data"
      end
      context "with invalid data" do
        include_examples "an update with invalid data"
      end
      context "permitted attributes" do
        include_examples "setup update request before each" 
        it "should allow name, description, group and materials to be set" do
          fake_params.should_receive(:permit).with(:name, :description, :group, consists_of_materials_attributes: [:id, :amount, :material_id, :_destroy])
          put :update, format: :json, id: 1
        end
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

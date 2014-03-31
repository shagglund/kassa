require 'spec_helper'

describe Buy do
  subject { FactoryGirl.build :buy }

  it {should validate_presence_of :buyer_id}
  it {should belong_to(:buyer).class_name 'User' }

  it {should have_many :consists_of_products}
  it {should have_many(:products).through :consists_of_products }

  context "#consists_of_products" do
    it "should have at least a single product" do
      subject.consists_of_products = []
      subject.should_not be_valid
      subject.should have(1).error_on(:consists_of_products)
    end

    it "should have all the products in stock" do
      zero_stock_on_first
      subject.should_not be_valid
      subject.should have(1).error_on first_product_name
    end
    def zero_stock_on_first
      subject.consists_of_products.first.product.stock = 0
    end
    def first_product_name
      subject.consists_of_products.first.product.name.to_sym
    end
  end

  context "custom scopes" do
    context ".latest" do
      let(:obj) {double.as_null_object}

      it "should order by created at in descending order" do
        Buy.should_receive(:in_create_order).and_return obj
        Buy.latest
      end
      it "should limit the results to 20 by default" do
        Buy.stub(:in_create_order).and_return obj
        obj.should_receive(:limit).with(20)
        Buy.latest
      end
      it "should limit the results to <limit>" do
        Buy.stub(:in_create_order).and_return obj
        obj.should_receive(:limit).with(15)
        Buy.latest(15)
      end
    end
    context ".in_create_order" do
      it "should sort the results by created_at in descending order" do
        Buy.should_receive(:order).with({created_at: :desc})
        Buy.in_create_order
      end
    end
  end
end

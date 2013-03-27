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

    it "should change the price when added" do
      price = subject.price
      entry = FactoryGirl.build(:buy_entry)
      subject.consists_of_products << entry
      subject.price.should be_within(0.001).of(price + entry.price)
    end

    it "should change the price when removed" do
      price = subject.price
      entry = subject.consists_of_products.pop
      subject.price.should be_within(0.001).of(price-entry.price)
    end

    it "should use the price from database unless a product was added" do
      subject.should_receive(:product_count_changed?).and_return false
      subject.should_not_receive(:consists_of_products)
      subject.price
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
        Buy.stub(:with_buyer_and_products).and_return obj
        obj.should_receive(:in_create_order).and_return obj
        Buy.latest
      end
      it "should limit the results to 20 by default" do
        Buy.stub_chain(:with_buyer_and_products, :in_create_order).and_return obj
        obj.should_receive(:limit).with(20)
        Buy.latest
      end
      it "should limit the results to <limit>" do
        Buy.stub_chain(:with_buyer_and_products, :in_create_order).and_return obj
        obj.should_receive(:limit).with(15)
        Buy.latest(15)
      end
      it "should eager load the buyer and products" do
        Buy.should_receive(:with_buyer_and_products).and_call_original
        Buy.latest
      end
    end
    context ".in_create_order" do
      it "should sort the results by created_at in descending order" do
        Buy.should_receive(:order).with 'buys.created_at DESC'
        Buy.in_create_order
      end
    end
  end
end

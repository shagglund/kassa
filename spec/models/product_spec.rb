require 'spec_helper'

describe Product do
  it 'should validate uniqueness of name' do
    FactoryGirl.build(:product).save(validate: false)
    should validate_uniqueness_of :name
  end
  it {should validate_presence_of :name}

  it {should ensure_inclusion_of(:group).in_array Product.groups}
  it "should provide translation to the groups in a hash" do
    Product.localized_groups.each_pair do |group, translation|
      translation.should eq I18n.t("activerecord.attributes.product.groups.#{group}")
    end
  end

  it {should have_many :consists_of_materials}

  it {should have_many(:materials).through :consists_of_materials}

  subject(:product){FactoryGirl.build :product_with_materials}

  context "#price" do
    it "should be calculated from all linked materials" do
      price = product.consists_of_materials.inject(0){|p,e| p+e.price}
      product.price.should eq price
    end
  end

  context "#stock" do
    it "should be calculated from all linked materials" do
      stock = product.consists_of_materials.min_by{|m| m.stock}.stock
      product.stock.should eq stock
    end
  end

  context "#material_least_in_stock" do
    it "should return the limiting material" do
      mat = product.consists_of_materials.min_by{|m| m.stock}
      product.material_least_in_stock.should eq mat
    end
  end
  context ".in_stock scope" do
    it "should return products where stock > 0" do
      subj = FactoryGirl.create :product_with_materials
      m = subj.consists_of_materials.first.material
      m.stock = 0
      m.save
      Product.in_stock.all.should_not include(subj)
    end
  end
end

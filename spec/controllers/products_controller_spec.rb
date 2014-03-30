require 'spec_helper'

describe ProductsController do
  render_views
  context "requests" do
    let(:product_attribs){FactoryGirl.attributes_for(:product)}
    let(:product){FactoryGirl.create(:product)}

    context "as an authenticated user" do
      login_user

      describe 'GET index' do
        it "should render a list of products" do
          get :index, format: :json
          expect(response.body).to render_template('index')
        end
      end

      describe 'GET show' do
        it "should render a given product by id" do
          get :show, format: :json, id: product.id
          expect(response).to render_template('show')
        end
        it "should render a given product by name" do
          get :show, format: :json, id: product.name
          expect(response).to render_template('show')
        end
      end

      describe "POST create" do
        it "should create a new product" do
          expect{
            post :create, format: :json, product: product_attribs
            expect(response.status).to eq 200
            expect(response).to render_template('create')

            new_product = Product.last
            expect(new_product.name).to eq(product_attribs[:name])
            expect(new_product.price).to eq(product_attribs[:price])
            expect(new_product.description).to eq(product_attribs[:description])
            expect(new_product.available).to eq(product_attribs[:available])
          }.to change(Product, :count).by(1)
        end
      end

      describe "PUT update" do
        it "should allow update to name, price, description and availability" do
          expect{
            expect{
              expect{
                expect{
                  put :update, format: :json, id: product.id, product: product_attribs
                  expect(response.status).to eq 200
                  expect(response).to render_template('update')
                  product.reload
                }.to change{product.name}
              }.to change{product.price}
            }.to change{product.description}
          }.to change{product.available}
        end
      end
    end

    context "unauthenticated" do
      describe "GET index" do
        it "should return 401 Unauthorized" do
          get :index, format: :json
          expect(response.status).to eq 401
        end
      end
      describe "GET show" do
        it "should return 401 Unauthorized" do
          get :show, format: :json, id: product.id
          expect(response.status).to eq 401
        end
      end
      describe "POST create" do
        it "should return 401 Unauthorized" do
          post :create, format: :json, product: product_attribs
          expect(response.status).to eq 401
        end
      end
      describe "PUT update" do
        it "should return 401 Unauthorized" do
          put :update, format: :json, id: product.id, product: product_attribs
          expect(response.status).to eq 401
        end
      end
    end
  end
end
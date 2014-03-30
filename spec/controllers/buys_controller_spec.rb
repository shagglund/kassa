require 'spec_helper'

describe BuysController do
  render_views
  context "requests" do
    let(:buy_attribs){FactoryGirl.attributes_for(:buy)}
    let(:buy){FactoryGirl.create(:buy)}
    let(:product){FactoryGirl.create(:product, available: true)}

    context "as an authenticated user" do
      login_user

      describe 'GET index' do
        render_views
        it "should render a list of buys" do
          buy
          get :index, format: :json
          expect(response).to render_template('index')
          expect(JSON.parse(response.body)['buys'].collect{|b| b['id']}).to include(buy.id)
        end
        it "should render buys only for user if requested" do
          buy #create a buy that's not for this user
          get :index, format: :json, user_id: current_user.id
          expect(response).to render_template('index')
          expect(JSON.parse(response.body)['buys'].collect{|b| b['id']}).to_not include(buy.id)
        end
        it "should render buys only for product if requested" do
          buy #create a buy that's not for this product
          get :index, format: :json, product_id: product.id
          expect(response).to render_template('index')
          expect(JSON.parse(response.body)['buys'].collect{|b| b['id']}).to_not include(buy.id)
        end
      end

      describe 'GET show' do
        it "should render a given buy by id" do
          get :show, format: :json, id: buy.id
          expect(response).to render_template('show')
        end
      end

      describe "POST create" do
        it "should create a new buy" do
          expect{
            buy_attribs['products'] = [{amount: 1, product_id: product.id.to_s}]
            buy_attribs['buyer_id'] = current_user.id.to_s
            post :create, format: :json, buy: buy_attribs
            expect(response.status).to eq 200
            expect(response).to render_template('create')
          }.to change(Buy, :count).by(1)
        end
        it "should not create a new buy with non-existent user" do
          expect{
            buy_attribs['products'] = [{amount: 1, product_id: product.id.to_s}]
            buy_attribs['buyer_id'] = (User.maximum(:id) + 1).to_s
            post :create, format: :json, buy: buy_attribs
            expect(response.status).to eq 422
          }.to_not change(Buy, :count)
        end
        it "should not create a new buy with non-existent product" do
          expect{
            product
            buy_attribs['products'] = [{amount: 1, product_id: (Product.maximum(:id) + 1).to_s}]
            buy_attribs['buyer_id'] = current_user.id.to_s
            post :create, format: :json, buy: buy_attribs
            expect(response.status).to eq 422
          }.to_not change(Buy, :count)
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
          get :show, format: :json, id: buy.id
          expect(response.status).to eq 401
        end
      end
      describe "POST create" do
        it "should return 401 Unauthorized" do
          post :create, format: :json, buy: buy_attribs
          expect(response.status).to eq 401
        end
      end
    end
  end
end
require 'spec_helper'

describe BalanceChangesController do
  render_views
  context "authenticated as an admin" do
    login_admin
    let(:user){FactoryGirl.create(:user)}
    let(:balance_change){FactoryGirl.create(:balance_change, trackable: user, doer: current_user)}

    describe "GET index" do
      it "renders the application" do
        balance_change
        get :index, user_id: user.id, format: :json
        expect(response.status).to eq 200
        expect(response).to render_template('index')
        expect(JSON.parse(response.body)['balanceChanges'].collect{|b| b['id']}).to include(balance_change.id)
      end
    end
  end

  context "authenticated as an user" do
    describe "GET index" do
      login_user
      it "should return 401 Unauthorized on self" do
        get :index, user_id: current_user.id, format: :json
        expect(response.status).to eq 401
      end
      it "should return 401 Unauthorized on any user" do
        get :index, user_id: current_user.id, format: :json
        expect(response.status).to eq 401
      end
    end
  end

  context "unauthenticated" do
    describe "GET index" do
      it "should return 401 Unauthorized" do
        get :index, user_id: 1, format: :json
        expect(response.status).to eq 401
      end
    end
  end
end
require 'spec_helper'

describe ApplicationController do
  context "authenticated" do
    login_user
    describe "GET index" do
      render_views
      it "renders the application" do
        get :index
        expect(response.status).to eq 200
        expect(response.body).to match /Buy/m
        expect(response.body).to match /Users/m
        expect(response.body).to match /Products/m
      end
    end
  end

  context "unauthenticated" do
    describe "GET index" do
      render_views
      it "renders the application" do
        get :index
        expect(response.status).to redirect_to(new_user_session_path)
      end
    end
  end
end
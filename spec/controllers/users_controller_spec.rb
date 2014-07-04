require 'spec_helper'

describe UsersController do
  render_views
  context "requests" do
    let(:user_attribs){FactoryGirl.attributes_for(:user)}
    let(:user_balance_attribs){{balance: user.balance + 100, description: 'Testing balance change on request level'}}
    let(:user){FactoryGirl.create(:user)}

    context "as an authenticated user" do
      login_user

      describe 'GET index' do
        it "should render a list of users" do
          get :index, format: :json
          expect(response).to render_template('index')
        end
      end

      describe 'GET show' do
        it "should render a given user by id" do
          get :show, format: :json, id: user.id
          expect(response).to render_template('show')
        end
        it "should render a given user by username" do
          get :show, format: :json, id: user.username
          expect(response).to render_template('show')
        end
      end

      describe 'GET me' do
        it "should render the current logged in user" do
          get :me, format: :json
          expect(response).to render_template('me')
        end
      end

      describe "POST create" do
        it "should return 401 Unauthorized" do
          expect{
            post :create, format: :json, user: user_attribs
            expect(response.status).to eq 401
          }.to_not change(User, :count)
        end
      end

      describe "PUT update" do
        it "should return 401 Unauthorized unless updating current user" do
          expect{
            put :update, format: :json, id: user.id, user: user_attribs
            expect(response.status).to eq 401
          }.to_not change{user}
        end

        it "should allow update to username and email if updating current user" do
          expect{
            expect{
              expect{
                put :update, format: :json, id: current_user.id, user: user_attribs
                current_user.reload
                expect(response.status).to eq 200
                expect(response).to render_template('update')
              }.to_not change{current_user.balance}
            }.to change{current_user.username}
          }.to change{current_user.email}
        end
      end

      describe "PUT update_balance" do
        it "should return 401 Unauthorized unless updating current user" do
          expect{
            put :update_balance, format: :json, id: user.id, user: user_balance_attribs
            expect(response.status).to eq 401
          }.to_not change{user}
        end
      end
    end

    context "as an authenticated admin" do
      login_admin

      describe 'POST create' do
        it "should create a new user" do
          expect{
            user_attribs[:password] = 'password'
            user_attribs[:password_confirmation] = 'password'
            post :create, format: :json, user: user_attribs
            expect(response.status).to eq 200
            expect(response).to render_template('create')
            new_user = User.last
            expect(new_user.username).to eq(user_attribs[:username])
            expect(new_user.email).to eq(user_attribs[:email])
            expect(new_user.balance).to eq(user_attribs[:balance])
            expect(new_user.admin).to eq(user_attribs[:admin])
            expect(new_user.valid_password?(user_attribs[:password])).to be true
            expect(new_user.valid_password?(user_attribs[:password] + '123')).to be false
          }.to change(User, :count).by(1)
        end
      end

      describe 'PUT update' do
        it "should allow changes to username, email and admin flag but not balance" do
          expect{
            expect{
              expect{
                expect{
                  user_attribs[:admin] = !user.admin
                  put :update, format: :json, id: user.id, user: user_attribs
                  user.reload
                  expect(response.status).to eq 200
                  expect(response).to render_template('update')
                }.to_not change{user.balance}
              }.to change{user.admin}
            }.to change{user.username}
          }.to change{user.email}
        end
      end

      describe 'PUT update_balance' do
        it "should change the balance" do
          expect{
            expect{
              put :update_balance, format: :json, id: user.id, user: user_balance_attribs
              user.reload
              expect(response.status).to eq 200
              expect(response).to render_template('update_balance')
              expect(user.balance_changes.last.change_note).to eq(user_balance_attribs[:description])
            }.to change{user.balance}.from(user.balance).to(user_balance_attribs[:balance])
          }.to change(BalanceChange, :count).by(1)
        end

        it "should not change balance without balance and description" do
          expect{
            expect{
              put :update_balance, format: :json, id: user.id, user: user_balance_attribs.slice(:balance)
              expect(response.status).to eq 422
              put :update_balance, format: :json, id: user.id, user: user_balance_attribs.slice(:description)
              expect(response.status).to eq 422
            }.to_not change{user.balance}
          }.to_not change(BalanceChange, :count)
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
          get :show, format: :json, id: user.id
          expect(response.status).to eq 401
        end
      end
      describe "GET me" do
        it "should return 401 Unauthorized" do
          get :me, format: :json
          expect(response.status).to eq 401
        end
      end
      describe "POST create" do
        it "should return 401 Unauthorized" do
          post :create, format: :json, user: user_attribs
          expect(response.status).to eq 401
        end
      end
      describe "PUT update" do
        it "should return 401 Unauthorized" do
          put :update, format: :json, id: user.id, user: user_attribs
          expect(response.status).to eq 401
        end
      end
      describe "PUT update_balance" do
        it "should return 401 Unauthorized" do
          put :update_balance, format: :json, id: user.id, user: user_balance_attribs
          expect(response.status).to eq 401
        end
      end
    end
  end
end
class UsersController < ApplicationController
  respond_to :json
  before_filter :find_user, only: [:show, :update]
  before_filter :authenticate_admin!, only: :create
  before_filter :authenticate_admin_if_not_self!, only: :update

  def index
    @users = User.all
    respond_with @users
  end
  
  def me
    @user = current_user
    respond_with @user
  end

  def show
    respond_with @user
  end

  def create
    @user = User.create user_params
    respond_with @user
  end

  def update
    @user.update_attributes user_params
    respond_with @user
  end

  private
  def find_user
    @user = User.find params[:id]
  end

  def user_params
    req = params.require(:user)
    if current_user.admin? and params[:action] == 'create'
      req.permit(:password, :password_confirmation, :username, :email, :admin, :staff, :balance)
    elsif current_user.admin?
      req.permit(:username, :email, :admin, :staff, :balance)
    elsif current_user == @user #allow self update of these fields
      req.permit(:username, :email, :balance)
    else
      req.permit()
    end
  end

  def authenticate_admin_if_not_self!
    authenticate_admin! unless current_user == @user
  end
end

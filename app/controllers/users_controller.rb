class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_admin!, only: [:create, :update_balance]
  before_filter :find_user, only: [:show, :update, :update_balance]
  before_filter :authenticate_admin_if_not_self!, only: :update

  def index
    respond_with User.all.order(:username)
  end

  def me
    respond_with current_user
  end

  def show
    respond_with @user
  end

  def create
    respond_with User.create user_create_params
  end

  def update
    @user.update_attributes user_update_params
    respond_with @user
  end

  def update_balance
    balance, description = balance_params.values_at(:balance, :description)
    @user.change_balance(balance, description, current_user)
    respond_with @user
  end

  private
  def find_user
    @user = User.with_id_or_username(params[:id]).first
  end

  def user_create_params
    params.require(:user).permit(:password, :password_confirmation, :username, :email, :admin, :balance)
  end

  def user_update_params
    req = params.require(:user)
    if current_user.admin?
      req.permit(:username, :email, :admin)
    else
      req.permit(:username, :email)
    end
  end

  def balance_params
    params.require(:user).permit(:balance, :description)
  end

  def authenticate_admin_if_not_self!
    authenticate_admin! unless current_user == @user
  end
end

class UsersController < ApplicationController
  respond_to :json
  before_filter :find_user, only: [:show, :update]
  before_filter :authenticate_admin!, only: :create
  before_filter :authenticate_admin_if_not_self!, only: :update

  def index
    respond_with User.all
  end

  def me
    respond_with current_user
  end

  def show
    respond_with @user
  end

  def create
    respond_with User.create user_params
  end

  def update
    @user.update_attributes user_params
    respond_with @user
  end

  private
  def find_user
    @user = User.with_id_or_username(params[:id]).first
  end

  def user_params
    req = params.require(:user)
    if current_user.admin? and params[:action] == 'create'
      req.permit(:password, :password_confirmation, :username, :email, :admin, :balance)
    elsif current_user.admin?
      req.permit(:username, :email, :admin)
    elsif current_user == @user #allow self update of these fields
      req.permit(:username, :email)
    else
      req.permit()
    end
  end

  def authenticate_admin_if_not_self!
    authenticate_admin! unless current_user == @user
  end
end

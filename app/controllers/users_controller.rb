class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_admin!, except: [:index, :show, :current]
  before_filter :find_user, only: [:show, :update]

  def index
    @users = User.all
    respond_with @users
  end
  
  def current
    @user = current_user
    respond_with @user
  end

  def show
    respond_with @user
  end

  def create
    @user = User.create params[:user]
    respond_with @user
  end

  def update
    maybe_set_admin
    maybe_set_staff
    @user.update_attributes params[:user]
    respond_with @user
  end

  private
  def find_user
    @user = User.find params[:id]
  end
  def maybe_set_admin
    @user.admin = !!params[:user].delete(:admin) if params.has_key? :admin
  end
  def maybe_set_staff
    @user.staff = !!params[:user].delete(:staff) if params.has_key? :staff
  end
end

class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, :only => [:create, :update]
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create

  end

  def update

  end
end

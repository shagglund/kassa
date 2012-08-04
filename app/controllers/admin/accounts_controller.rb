class Admin::AccountsController < ApplicationController
  respond_to :json

  def index
    @accounts = User.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def create
  end

  def delete
  end
end

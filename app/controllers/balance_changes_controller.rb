class BalanceChangesController < ApplicationController
  respond_to :json
  before_filter :authenticate_admin!
  before_filter :find_user

  def index
    @balance_changes = @user.balance_changes.includes(:doer)
    @doers = @balance_changes.map{|c| c.doer}
  end

  protected
  def find_user
    @user = User.with_id_or_username(params[:user_id]).first
  end
end
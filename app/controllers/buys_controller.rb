class BuysController < ApplicationController
  respond_to :json

  def index
    limit = params[:limit] || 20
    offset = params[:offset] || 0
    respond_with base_scope.offset(offset).latest(limit).all
  end

  def show
    respond_with Buy.where(id: params[:id].to_i).first
  end

  def create
    respond_with Buy.create(buy_params)
  end

  private
  def base_scope
    if params[:user_id].present?
      Buy.with_buyer(params[:user_id])
    elsif params[:product_id].present?
      Buy.with_product(params[:product_id])
    else
      Buy
    end
  end

  def buy_params
    params.require(:buy).permit(:buyer_id, :price, consists_of_products_attributes:[:amount, :product_id])
  end
end

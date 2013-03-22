class BuysController < ApplicationController
  respond_to :json
  before_filter :find_buy, only: :show
  def index
    limit = params[:limit] || 20
    offset = params[:offset] || 0
    @buys = Buy.offset(offset).latest(limit).all
    respond_with @buys
  end

  def show
    respond_with @buy
  end

  def create
    @buy = Buy.create buy_params
    respond_with @buy
  end

  private
  def find_buy
    @buy = Buy.find params[:id]
  end

  def buy_params
    params.require(:buy).permit(:buyer_id, :price, consists_of_products_attributes:[:amount, :product_id])
  end
end

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
    @buy = Buy.create params[:buy]
    respond_with @buy
  end

  private
  def find_buy
    @buy = Buy.find params[:id]
  end
end

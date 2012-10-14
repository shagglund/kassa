class BuysController < ApplicationController
  respond_to :json
  def index
    @buys = Buy.eager_load{buyer}.order('buys.created_at DESC').limit(20).all
    render json: @buys
  end

  # GET /buys/1
  # GET /buys/1.json
  def show
    @buy = Buy.find(params[:id])
    render json: @buy
  end

  # POST /buys
  # POST /buys.json
  def create
    @buy = Buy.new(params[:buy])
    if @buy.save
      render json: {status: 'created', object: @buy}, status: :created, location: @buy
    else
      render json: @buy.errors, status: :unprocessable_entity
    end
  end
end

class ProductsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, :only => [:create, :update, :destroy]
  before_filter :find_product, :only => [:show, :update, :destroy]

  def index
    @products = Product.eager_load{materials.material}.all
    @products.delete_if {|product| product.stock == 0} if params[:in_stock]
  end

  def show
    @product
    render json: @product
  end

  def create
    @product = Product.new(params[:product])

    if @product.save
      render 'show'
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update_attributes(params[:product])
      render 'show'
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private
    def find_product
      @product = Product.find(params[:id])
    end
end

class ProductsController < ApplicationController
  respond_to :json
  before_filter :find_product, only: [:show, :update]
  def index
    @products = Product.all
    respond_with @products
  end

  def show
    respond_with @product
  end

  def create
    @product = Product.create product_params
    respond_with @product
  end

  def update
    @product.update_attributes product_params
    respond_with @product
  end

  private
  def find_product
    @product = Product.with_id_or_name(params[:id]).first
  end

  def product_params
    params.require(:product).permit(:name, :available, :price, :description)
  end
end

class ProductsController < ApplicationController
  respond_to :json
  before_filter :find_product, only: [:show, :update, :destroy]
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

  def destroy
    @product.destroy
    respond_with @product
  end

  private
  def find_product
    if numeric_id?(params[:id])
      @product = Product.where(id: params[:id].to_i).first
    else
      @product = Product.where(name: params[:id]).first
    end
  end

  def product_params
    params.require(:product).permit(:unit, :group, :name, :price, :stock, :description)
  end
end

class BasicProductsController < ApplicationController
  respond_to :json
  before_filter :find_basic_product, only: [:show, :update, :destroy]
  def index
    @basic_products = BasicProduct.all
    respond_with @basic_products
  end

  def show
    respond_with @basic_product
  end

  def create
    @basic_product = BasicProduct.create basic_product_params
    respond_with @basic_product
  end

  def update
    @basic_product.update_attributes basic_product_params
    respond_with @basic_product  
  end

  def destroy
    @basic_product.destroy
    respond_with @basic_product
  end

  private
  def find_basic_product
    @basic_product = BasicProduct.find params[:id]
  end

  def basic_product_params
    params.require(:basic_product).permit(:unit, :group, :name, :price, :stock, :description) 
  end
end

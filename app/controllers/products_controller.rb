class ProductsController < ApplicationController
  respond_to :json
  before_filter :find_product, only: [:show, :update, :destroy]

  def index
    @products = product_scope_by_params.all
    respond_with @products
  end

  def show
    respond_with @product
  end

  def create
    @product = Product.create params[:product]
    respond_with @product
  end

  def update
    @product.update_attributes params[:product]
    respond_with @product
  end

  def destroy
    @product.destroy
    respond_with @product
  end

  private
    def find_product
      @product = Product.find params[:id]
    end
    def product_scope_by_params
      if !!params[:in_stock]
        Product.in_stock
      else 
        Product
      end
    end
end

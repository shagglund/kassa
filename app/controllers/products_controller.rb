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
      @product = Product.find params[:id]
    end
    def product_params
      entry_attributes = [:id, :amount, :material_id, :_destroy]
      params.require(:product).permit(:name, :description, :group, consists_of_materials_attributes: entry_attributes)
    end
    def product_scope_by_params
      if !!params[:in_stock]
        Product.in_stock
      else 
        Product
      end
    end
end

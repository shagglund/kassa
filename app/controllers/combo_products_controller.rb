class ComboProductsController < ApplicationController
  respond_to :json
  before_filter :find_combo_product, only: [:show, :update, :destroy]

  def index
    @combo_products = combo_product_scope_by_params.all
    respond_with @combo_products
  end

  def show
    respond_with @combo_product
  end

  def create
    @combo_product = ComboProduct.create combo_product_params
    respond_with @combo_product
  end

  def update
    @combo_product.update_attributes combo_product_params
    respond_with @combo_product
  end

  def destroy
    @combo_product.destroy
    respond_with @combo_product
  end

  private
    def find_combo_product
      @combo_product = ComboProduct.find params[:id]
    end
    def combo_product_params
      entry_attributes = [:id, :amount, :material_id, :_destroy]
      params.require(:combo_product).permit(:name, :description, :group, consists_of_materials_attributes: entry_attributes)
    end
    def combo_product_scope_by_params
      if !!params[:in_stock]
        ComboProduct.in_stock
      else 
        ComboProduct
      end
    end
end

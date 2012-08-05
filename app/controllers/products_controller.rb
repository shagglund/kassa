class ProductsController < ApplicationController

  def index
    @products = Product.
        includes(:product_entries => :material).
        joins(:product_entries => :material).
        all
    respond_to do |format|
      format.json {render json: @products.to_json({:include => {:product_entries => {:include => :material}}})}
    end
  end

  def show
    @product = Product.
        includes(:product_entries => :material).
        joins(:product_entries => :material)
        find(params[:id])
    respond_to do |format|
      format.json {render json: @product.to_json({:include => {:product_entries => {:include => :material}}})}
    end
  end
end

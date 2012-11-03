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
    entries_hash = params[:product].extract! :materials
    @product = Product.new(params[:product])
    materials = Material.where{id.in(entries_hash.keys)}.all
    materials.each do |material|
      @product.materials.build({:material => material, :amount => entries_hash[material.id.to_s]})
    end

    if @product.save
      render json: @product, status: :created, location: @product
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

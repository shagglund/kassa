class ProductEntriesController < ApplicationController
  before_filter :find_product
  before_filter :find_product_entry, :only => [:edit, :update, :destroy]

  # GET /product_entries/new
  # GET /product_entries/new.json
  def new
    @product_entry = @product.product_entries.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_entry }
    end
  end

  # GET /product_entries/1/edit
  def edit
  end

  # POST /product_entries
  # POST /product_entries.json
  def create
    @product_entry = @product.product_entries.create(params[:product_entry])
    respond_to do |format|
      if @product_entry.present?
        format.html { redirect_to @product, notice: 'Product entry was successfully created.' }
        format.json { render json: @product_entry, status: :created, location: @product_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_entries/1
  # PUT /product_entries/1.json
  def update
    respond_to do |format|
      if @product_entry.update_attributes(params[:product_entry])
        format.html { redirect_to @product_entry, notice: 'Product entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_entries/1
  # DELETE /product_entries/1.json
  def destroy
    @product_entry.destroy

    respond_to do |format|
      format.html { redirect_to product_path(@product) }
      format.json { head :no_content }
    end
  end

  private
    def find_product
      @product = Product.find(params[:product_id])
    end

    def find_product_entry
      @product_entry = @product.product_entries.find(params[:id])
    end
end

class MaterialsController < ApplicationController
  respond_to :json
  before_filter :find_material, only: [:show, :update, :destroy]
  def index
    @materials = Material.all
    respond_with @materials
  end

  def show
    respond_with @material
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.create(params[:material])
    respond_with @material
  end

  def update
    @material.update_attributes(params[:material])
    respond_with @material  
  end

  def destroy
    @material.destroy
    respond_with @material
  end

  private
  def find_material
    @material = Material.find params[:id]
  end
end

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

  def create
    @material = Material.create material_params
    respond_with @material
  end

  def update
    @material.update_attributes material_params
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

  def material_params
    params.require(:material).permit(:unit, :group, :name, :price, :stock) 
  end
end

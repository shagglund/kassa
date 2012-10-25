class MaterialsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, :only => [:create, :update, :destroy]
  def index
    @materials = Material.all
    render json: @materials
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
    @material = Material.find(params[:id])
    render json: @material
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(params[:material].merge(:action_by => current_user))
    if @material.save
      render json: @material, status: :created, location: @material
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # PUT /materials/1
  # PUT /materials/1.json
  def update
    @material = Material.find(params[:id])
    if @material.update_attributes(params[:material].merge(:action_by => current_user))
      head :no_content
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material = Material.find(params[:id])
    @material.destroy
    head :no_content
  end
end

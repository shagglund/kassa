class BuysController < ApplicationController
  respond_to :json

  def index
    limit = params[:limit] || 20
    offset = params[:offset] || 0
    respond_with base_scope.offset(offset).latest(limit).all
  end

  def show
    respond_with Buy.where(id: params[:id].to_i).first
  end

  def create
    ensure_user_exists do
      ensure_products_exist do
        return respond_with Buy.create(buy_params)
      end
    end
  end

  private
  def base_scope
    if params[:user_id].present?
      Buy.with_buyer(params[:user_id])
    elsif params[:product_id].present?
      Buy.with_product(params[:product_id])
    else
      Buy
    end
  end

  def buy_params
    params.require(:buy).permit(:buyer_id, :price, products: [:amount, :product_id]).tap do |whitelisted|
      whitelisted[:consists_of_products_attributes] = whitelisted.delete(:products)
    end
  end

  def ensure_user_exists
    unless User.with_id_or_username(buy_params[:buyer_id]).exists?
      return head :unprocessable_entity
    end
    yield
  end

  def ensure_products_exist
    buy_params[:consists_of_products_attributes].each do |entry_attribs|
      unless Product.with_id_or_name(entry_attribs[:product_id]).exists?
        return head :unprocessable_entity
      end
    end
    yield
  end
end

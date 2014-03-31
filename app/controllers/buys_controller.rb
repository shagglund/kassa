class BuysController < ApplicationController
  respond_to :json
  integer_param_method :limit, default: 20, min: 10, max: 500
  integer_param_method :offset, default: 0
  param_method :product_id, default: nil
  param_method :user_id, default: nil

  def index
    @buys = buy_scope.offset(offset).latest(limit).all
    @buyers =  buyers(@buys)
    @products = products(@buys)
  end

  def show
    @buy = Buy.with_buyer_and_products.where(id: params[:id].to_i).first
  end

  def create
    ensure_user_exists(buy_params) do |resolved_params|
      ensure_products_exist(resolved_params) do |resolved_params|
        return respond_with(@buy = Buy.create(resolved_params))
      end
    end
  end

  private
  def buy_scope
    scope = if user_id.present?
      Buy.for_buyer(user)
    elsif product_id.present?
      Buy.for_product(product)
    else
      Buy
    end
    scope.includes(:consists_of_products)
  end

  def buy_params
    params.require(:buy).permit(:buyer_id, :price, products: [:amount, :product_id]).tap do |whitelisted|
      whitelisted[:consists_of_products_attributes] = whitelisted.delete(:products)
    end
  end

  def ensure_user_exists(resolved_params)
    user = User.with_id_or_username(resolved_params.delete(:buyer_id)).first
    if user.nil?
      return head :unprocessable_entity
    else
      resolved_params[:buyer] = user
      yield resolved_params
    end
  end

  def ensure_products_exist(resolved_params)
    resolved_params[:consists_of_products_attributes].each do |entry_attribs|
      product = Product.with_id_or_name(entry_attribs.delete(:product_id)).first
      if product.nil?
        return head :unprocessable_entity
      else
        entry_attribs[:product] = product
      end
    end
    yield resolved_params
  end

  def products(buys)
    if product_id.nil?
      Product.where(id: buys.map(&:consists_of_products).flatten.map(&:product_id).uniq).all
    else
      Array(product)
    end
  end

  def buyers(buys)
    if user_id.nil?
      User.where(id: buys.map(&:buyer_id).uniq).all
    else
      Array(user)
    end
  end

  def user
    @user ||= User.with_id_or_username(user_id).first
  end

  def product
    @product ||= Product.with_id_or_name(product_id)
  end
end

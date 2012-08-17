class HomesController < ApplicationController
  def index
    @buy = Buy.new
    @users = User.buyer_listable
    @products = Product.sale_listable
  end
end

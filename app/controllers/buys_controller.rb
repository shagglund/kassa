class BuysController < ApplicationController
  # GET /buys
  # GET /buys.json
  before_filter :buyers_and_products, :only => [:new, :create]
  before_filter :find_buyer_or_remove, :only => :new
  before_filter :build_buy, :only => :new
  before_filter :build_buy_entries, :only => :new


  def index
    @buys = Buy.all

    respond_to do |format|
      format.html # index.html.erb.erb
      format.json { render json: @buys }
    end
  end

  # GET /buys/1
  # GET /buys/1.json
  def show
    @buy = Buy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buy }
    end
  end

  # GET /buys/new
  # GET /buys/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buy }
    end
  end

  # GET /buys/1/edit
  def edit
    @buy = Buy.find(params[:id])
  end

  # POST /buys
  # POST /buys.json
  def create
    @buy = Buy.new(params[:buy])

    respond_to do |format|
      if @buy.save
        session[:buyer] = nil
        session[:buy_entries] = nil
        @buy = nil
        format.html { redirect_to new_buy_path, notice: I18n.t('buys.success') }
        format.json { render json: @buy, status: :created, location: @buy }
      else
        format.html { render action: "new" }
        format.json { render json: @buy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buys/1
  # PUT /buys/1.json
  def update
    @buy = Buy.find(params[:id])

    respond_to do |format|
      if @buy.update_attributes(params[:buy])
        format.html { redirect_to @buy, notice: 'Buy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buys/1
  # DELETE /buys/1.json
  def destroy
    @buy = Buy.find(params[:id])
    @buy.destroy

    respond_to do |format|
      format.html { redirect_to buys_url }
      format.json { head :no_content }
    end
  end

  private
    def build_buy
      @buy = Buy.new
      @buy.buyer = @buyer if @buyer.present?
    end

    def find_buyer_or_remove
      unless params[:remove_buyer].present?
        @buyer = User.find(params[:buyer]) if params[:buyer].present?
        @buyer = User.find(session[:buyer]) if session[:buyer].present? and @buyer.nil?
      end
      session[:buyer] = @buyer
    end

    def build_buy_entries
      maybe_remove_product_from_session_basket
      maybe_add_product_to_session_basket
      return unless session[:buy_entries].present?
      entry_ids = session[:buy_entries].collect{|key, value| key}
      products = Product.where{id.in(entry_ids)}.all
      products.each do |product|
        entry = BuyEntry.new :product => product, :amount => session[:buy_entries][product.id]
        @buy.buy_entries << entry
      end
    end

    def maybe_add_product_to_session_basket
      if params[:add_product].present?
        session[:buy_entries] = {} unless session[:buy_entries].present?
        add_amount = params[:amount].present? ? params[:amount].to_i : 1
        add_amount += session[:buy_entries][params[:add_product].to_i] unless session[:buy_entries][params[:add_product].to_i].nil?
        session[:buy_entries][params[:add_product].to_i] = add_amount
      end
    end

    def maybe_remove_product_from_session_basket
      if params[:remove_product].present? and session[:buy_entries].present?
        session[:buy_entries].delete params[:remove_product].to_i
      end
    end

    def buyers_and_products
      @users = User.buyer_listable
      @products = Product.sale_listable
      @latest_buys = Buy.limit(20).all
    end
end

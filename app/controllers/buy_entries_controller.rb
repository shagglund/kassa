class BuyEntriesController < ApplicationController
  # GET /buy_entries
  # GET /buy_entries.json
  def index
    @buy_entries = BuyEntry.all

    respond_to do |format|
      format.html # index.html.erb.erb
      format.json { render json: @buy_entries }
    end
  end

  # GET /buy_entries/1
  # GET /buy_entries/1.json
  def show
    @buy_entry = BuyEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buy_entry }
    end
  end

  # GET /buy_entries/new
  # GET /buy_entries/new.json
  def new
    @buy_entry = BuyEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buy_entry }
    end
  end

  # GET /buy_entries/1/edit
  def edit
    @buy_entry = BuyEntry.find(params[:id])
  end

  # POST /buy_entries
  # POST /buy_entries.json
  def create
    @buy_entry = BuyEntry.new(params[:buy_entry])

    respond_to do |format|
      if @buy_entry.save
        format.html { redirect_to @buy_entry, notice: 'Buy entry was successfully created.' }
        format.json { render json: @buy_entry, status: :created, location: @buy_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @buy_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buy_entries/1
  # PUT /buy_entries/1.json
  def update
    @buy_entry = BuyEntry.find(params[:id])

    respond_to do |format|
      if @buy_entry.update_attributes(params[:buy_entry])
        format.html { redirect_to @buy_entry, notice: 'Buy entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buy_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buy_entries/1
  # DELETE /buy_entries/1.json
  def destroy
    @buy_entry = BuyEntry.find(params[:id])
    @buy_entry.destroy

    respond_to do |format|
      format.html { redirect_to buy_entries_url }
      format.json { head :no_content }
    end
  end
end

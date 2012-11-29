class BuysController < AuthenticationController
  respond_to :json
  def index
    limit = params[:limit] || 20
    offset = params[:offset] || 0
    @buys = Buy.latest(offset,limit)
    render json: @buys
  end

  # GET /buys/1
  # GET /buys/1.json
  def show
    @buy = Buy.find(params[:id])
    render json: @buy
  end

  # POST /buys
  # POST /buys.json
  def create
    @buy = Buy.new(params[:buy])
    if @buy.save
      render json: {status: :created, object: @buy, i18n_key: 'buys.success', message: I18n.t('buys.success')}, status: :created, location: @buy
    else
      render json: {status: :error, errors: @buy.errors, i18n_key: 'buys.failure', message: I18n.t('buys.failure')}, status: :unprocessable_entity
    end
  end
end

class UsersController < AuthenticationController
  respond_to :json

  def index
    @users = User.all
    render json: @users
  end

  def current
    render json: current_user
  end

  def create

  end

  def update

  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    authenticate_user!
  end
end

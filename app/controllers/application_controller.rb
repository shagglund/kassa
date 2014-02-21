class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def index
  end

  protected

  def authenticate_admin!
    authenticate_user! if current_user.nil?
    unless current_user.admin?
      Rails.logger.warn("Unauthorized attempt by #{current_user.username} to #{params[:controller]}##{params[:action]}")
      msg =I18n.t('errors.admin.not_authorized') 
      respond_to do |format|
        format.html { render text: msg, status: :forbidden}
        format.json {render json: msg, status: :forbidden}
      end
    end
  end
end

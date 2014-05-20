class ApplicationController < ActionController::Base
  class << self
    protected
    def get_value_within_limits(min, max, value)
    end

    def integer_param_method(param_name, opts={})
      define_method(param_name) do
        LimitedValuePicker.new(opts).get(params[param_name]).to_i
      end
    end

    def param_method(param_name, opts={})
      define_method(param_name) { params[param_name] }
    end
  end

  self.responder = PutPatchResponder
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def index
  end

  protected
  def authenticate_admin!
    authenticate_user! if current_user.nil?
    unless current_user.admin?
      log_admin_access_attempt
      respond_with_not_an_admin
    end
  end

  def log_admin_access_attempt
    Rails.logger.warn("Unauthorized attempt by #{current_user.username} to #{params[:controller]}##{params[:action]}")
  end

  def respond_with_not_an_admin
    msg =I18n.t('errors.admin.not_authorized')
    respond_to do |format|
      format.html { render text: msg, status: :forbidden}
      format.json {render json: msg, status: :forbidden}
    end
  end
end

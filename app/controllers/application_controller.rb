class ApplicationController < ActionController::Base
  class << self
    protected
    def integer_param_method(param_name, opts={})
      max, min, default = opts.values_at(:max, :min, :default)
      define_method(param_name) do
        value = params.has_key?(param_name) ? params[param_name].to_i : default
        return if value.nil?
        return max if max && value > max
        return min if min && value < min
        value
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
      Rails.logger.warn("Unauthorized attempt by #{current_user.username} to #{params[:controller]}##{params[:action]}")
      msg =I18n.t('errors.admin.not_authorized')
      respond_to do |format|
        format.html { render text: msg, status: :forbidden}
        format.json {render json: msg, status: :forbidden}
      end
    end
  end
end

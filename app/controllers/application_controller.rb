class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user_can_edit?
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pincode_valid?(event)
    return false if !event.pincode_valid?(cookies.permanent["events_#{event.id}_pincode"]) && event.pincode.present?

    true
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[password password_confirmation current_passwrod])
  end

  def current_user_can_edit?(model)
    user_signed_in? && (model.user == current_user || (model.try(:event).present? && model.event.user == current_user))
  end

  private

  def user_not_authorized
    flash[:alert] = t('pundit.not_authorized')
    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    UserContext.new(current_user, cookies)
  end
end

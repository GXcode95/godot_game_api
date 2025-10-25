# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers

  # API-only: pas de session/CSRF stateful, neutre pour JSON
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[nickname email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[nickname email password])
  end
end

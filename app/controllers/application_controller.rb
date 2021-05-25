class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit
  after_action :verify_authorized, only: [:edit, :update], unless: :skip_pundit?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :address, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:address, :avatar])
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

end

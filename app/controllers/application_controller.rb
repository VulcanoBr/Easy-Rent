# frozen_string_literal: true

class ApplicationController < ActionController::Base

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    redirect_to welcome_path, alert: "Voce não esta autorizado, a executar esta ação."
  end

  def authenticate_user_from_admin_url
    @request = request.fullpath
    unless admin_user_signed_in?
      redirect_to new_admin_user_session_path
    end
  end

  def pundit_user
    current_admin_user
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || welcome_path)
  end

end

# fronze_string_literal: true

class Admin::AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin_user!
  before_action :authorize_admin!

  private

  def authorize_admin!
    return if current_admin_user.admin?

    flash[:alert] = "You are not authorized to access this area."
    redirect_to new_admin_user_session_path
  end
end

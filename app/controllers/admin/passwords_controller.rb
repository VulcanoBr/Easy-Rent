# app/controllers/admin/users/passwords_controller.rb
class Admin::PasswordsController < Devise::PasswordsController

  layout "admin"

  def new
    super
  end

  # POST /resource/password
  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
    admin_dashboard_path
  end
end

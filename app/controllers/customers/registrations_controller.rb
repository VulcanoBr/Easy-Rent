class Customers::RegistrationsController < Devise::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    build_resource
  end

  def create
    super
  end

  def update; end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email name dob identification
                                                         mobile_phone address password confirmation_password])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email name dob identification
                                                                mobile_phone address password confirmation_password])
  end
end

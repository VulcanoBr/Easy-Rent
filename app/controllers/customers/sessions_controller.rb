# app/controllers/customer/sessions_controller.rb
module Customers
  class SessionsController < Devise::SessionsController

    def new
      self.resource = resource_class.new(sign_in_params)
      store_location_for(resource, params[:redirect_to])
      respond_with(resource, serialize_options(resource)) do |format|
        format.html { render template: "customer/sessions/new" }
      end
    end

    def create
      self.resource = warden.authenticate!(auth_options)
      if resource.role == "customer" || resource.role == "operator"
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        redirect_to location: after_sign_in_path_for(resource)
      else
        sign_out(resource)
        set_flash_message!(:alert, :unauthorized)
        redirect_to new_customer_user_session_path
      end
    end

    protected

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    end

    def after_sign_in_path_for(_resource)
      customer_dashboard_path
    end
  end
end

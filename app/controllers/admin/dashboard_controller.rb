# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < Admin::AdminController

    before_action :authorize_admin

    def index
      @total_equipaments = Equipament.total_count
      @available_equipaments_count = Equipament.available.count
      @maintenance_equipaments_count = Equipament.maintenance.count
      @maintenance_total_value = Maintenance.total_maintenance_value_for_current_year
      @order_summary = Order.current_year_completed_summary
      @total_orders = @order_summary.total_orders
      @total_value = @order_summary.total_value
    end

    private

    def authorize_admin
      return if current_admin_user&.admin?

      flash[:alert] = "Você não tem permissão para acessar essa página."
      redirect_to root_path
    end
  end
end

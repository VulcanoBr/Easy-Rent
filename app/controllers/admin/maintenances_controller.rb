# frozen_string_literal: true
module Admin
  class MaintenancesController < Admin::AdminController

    include Pagy::Backend

    before_action :load_maintenance, only: %i[update show]
    before_action :maintenance_edit, only: %i[edit]

    def index
      @pagy, @maintenances = pagy(Equipament.filtered_and_ordered(params[:search]), limit: 7)
      authorize(@maintenances)
    end

    def new
      @equipament = Equipament.find(params[:id])
      @max_date = Date.today
      @maintenance = Maintenance.new
      authorize(@maintenance)
    end

    def edit
      @equipament = Equipament.find(params[:id])
      @max_date = Date.today
    end

    def create
      @maintenance = Maintenance.new(maintenance_params)
      @maintenance.status =  "in_progress"
        authorize(@maintenance)
        if @maintenance.save
          equipament = Equipament.find(params[:maintenance][:equipament_id])
          equipament.maintenance!
          redirect_to(admin_maintenance_path(@maintenance), notice: "Manutenção cadastrada com sucesso !!!")
        else
          @max_date = Date.today #.strftime("%d/%m/%Y")
          @equipament = Equipament.find(maintenance_params[:equipament_id])
          render(:new, status: :unprocessable_entity)
        end
    end

    def update
      authorize(@maintenance)
        @maintenance.status = "finished"
        if @maintenance.update(maintenance_params)
          equipament = Equipament.find(params[:maintenance][:equipament_id])
          equipament.available!
          redirect_to(admin_maintenance_path(@maintenance), notice: "Manutenção atualizada com sucesso !!!")
        else
          @max_date = Date.today #.strftime("%d/%m/%Y")
          @equipament = Equipament.find(maintenance_params[:equipament_id])
          render(:edit, status: :unprocessable_entity)
        end
    end

    private

    def load_maintenance
      @maintenance = Maintenance.find(params[:id])
    end

    def maintenance_edit
      @maintenance = Maintenance.find_by(equipament_id: params[:id])
    end

    def maintenance_params
      params.require(:maintenance).permit(:equipament_id, :maintenance_type, :period_start,
                      :period_end, :maintenance_value, :status)
    end
  end
end

# frozen_string_literal: true

module Admin
  class EquipamentsController < Admin::AdminController

    include Pagy::Backend

    before_action :load_equipament, only: %i[show edit update destroy]

    def index
      if params[:search].present?
        @pagy, @equipaments = pagy(Equipament.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%"), limit: 9)
      else
        @pagy, @equipaments = pagy(Equipament.order(:name, :serial_number), limit: 9)
      end
      authorize(@equipaments)
    end

    def search
      period_start = params[:period_start]&.presence
      period_end = params[:period_end]&.presence

      if period_start
        @equipaments = Equipament
                       .availables(period_start, period_end)
                       .where("lower(name) ILIKE ?", "%#{params[:q]}%".downcase) # ransack(name_matches: params[:q])
                       .select(:id, :name, :serial_number, :rent_value)
      else
        @equipaments = Equipament.none
      end

      render(layout: false)
    end

    def show
      authorize(@equipament)
    end

    def new
      @equipament = Equipament.new
      authorize(@equipament)
    end

    def edit; end

    def create
      @equipament = Equipament.new(equipament_params)
      authorize(@equipament)
      if @equipament.save
        redirect_to(admin_equipament_path(@equipament), notice: "Equipamento cadastrado com sucesso !!!")
      else
        render(:new, status: :unprocessable_entity)
      end
    end

    def update
      authorize(@equipament)
      if @equipament.update(equipament_params)
        redirect_to(admin_equipament_path(@equipament), notice: "Equipamento atualizado com sucesso !!!")
      else
        render(:edit, status: unprocessable_entity)
      end
    end

    def destroy
      authorize(@equipament)
      @equipament.destroy!
      redirect_to(admin_equipaments_path, notice: "Equipamento deletado com sucesso !!!")
    end

    private

    def load_equipament
      @equipament = Equipament.find(params[:id])
    end

    def equipament_params
      params.require(:equipament).permit(:name, :serial_number, :description, :status,
                                         :rent_value, :image, :remove_image)
    end
  end
end

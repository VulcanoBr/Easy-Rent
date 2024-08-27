# frozen_string_literal: true

module Admin
  class OrdersController < Admin::AdminController

    include Pagy::Backend

    before_action :load_order, only: %i[show edit update destroy cancel_order payment_order finished_order]

    def index
      if params[:search].present?
        @pagy, @orders = pagy(Order.where("order_code LIKE ?", "%#{params[:search]}%"), limit: 9)
      else
        @pagy, @orders = pagy(Order.order(created_at: :desc), limit: 9)
      end
    end

    def show; end

    def new
      @order = Order.new
      @min_date = Date.today + 1
    end

    def edit; end

    def create
      @order = Order.new(order_params)
      # authorize @order
      if @order.save
        equipament = Equipament.find(order_params[:equipament_id])
        equipament.unavailable!
        OrderMailer.send_order_receipt(@order.id).deliver_later
        redirect_to(admin_order_path(@order), notice: "Pedido cadastrado com sucesso !!!")
      else
        @min_date = Date.today + 1 ## .strftime("%d/%m/%Y")
        render(:new, status: :unprocessable_content)
      end
    end

    def update
      if @order.update(order_params)
        redirect_to(admin_order_path(@order), notice: "Pedido atualizado com sucesso !!!")
      else
        render(:edit, status: :unprocessable_content)
      end
    end

    def destroy
      @order.destroy!
    end

    def put_fineshed_order
      if params[:search].present?
        @pagy, @orders = pagy(Order.in_progress_and_expired(params[:search]), limit: 9)
      else
        @pagy, @orders = pagy(Order.in_progress_and_expired, limit: 9)
      end
    end

    def put_canceled_order
      if params[:search].present?
        @pagy, @orders = pagy(Order.pending_and_expired(params[:search]), limit: 9)
      else
        @pagy, @orders = pagy(Order.pending_and_expired, limit: 9)
      end
    end

    def put_paid_order
      if params[:search].present?
        @pagy, @orders = pagy(Order.pending_not_expired(params[:search]), limit: 9)
      else
        @pagy, @orders = pagy(Order.pending_not_expired, limit: 9)
      end
    end

    def cancel_order
      @order.update_column(:status, "canceled")
      equipament = Equipament.find(@order.equipament_id)
      equipament.available!
      schedule = Schedule.find_by(order_id: @order.id)
      schedule.done!
      OrderMailer.send_order_canceled(@order.id).deliver_later
      redirect_to put_canceled_order_admin_orders_path, notice: "Pedido #{@order.order_code} cancelado !!"
    end

    def payment_order
      @order.update_column(:status, "inprogress")
      OrderMailer.send_order_payment(@order.id).deliver_later
      redirect_to put_paid_order_admin_orders_path, notice: "Pedido #{@order.order_code} pagamento confirmado !!"
    end

    def finished_order
      @order.update_column(:status, "finished")
      equipament = Equipament.find(@order.equipament_id)
      equipament.available!
      schedule = Schedule.find_by(order_id: @order.id)
      schedule.done!
      OrderMailer.send_order_canceled(@order.id).deliver_later
      redirect_to put_fineshed_order_admin_orders_path, notice: "Pedido #{@order.order_code} finalizado !!"
    end

    private

    def load_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(
        :customer_id,
        :equipament_id,
        :order_code,
        :period_start,
        :period_end,
        :status,
        :rent_value,
        :tot_rent_value,
        :payment_method,
        :installments,
        :pix_code,
        :ticket_barcode
      )
    end
  end
end

# frozen_string_literal: true

class RentalsController < ApplicationController

  before_action :authenticate_customer!
  before_action :load_order, only: %i[show]

  def show; end

  def new
    @equipament = Equipament.find(params[:id])
    @order = Order.new
    @min_date = Date.today + 1
  end

  def create
    @order = Order.new(order_params)
    @order.assign_attributes(credit_card_name: params[:order][:credit_card_name],
                            credit_card_number: params[:order][:credit_card_number],
                            credit_card_expiry_month: params[:order][:credit_card_expiry_month],
                            credit_card_expiry_year: params[:order][:credit_card_expiry_year],
                            credit_card_security_code: params[:order][:credit_card_security_code])

    if @order.valid?
      @order.save
      equipament = Equipament.find(order_params[:equipament_id])
      equipament.unavailable!
      OrderMailer.send_order_receipt(@order.id).deliver_later
      redirect_to rental_path(@order), notice: "Seu pedido foi concluido com sucesso!!"
    else
      @equipament = Equipament.find(order_params[:equipament_id])
      @min_date = (Date.today + 1) ## .strftime("%d/%m/%Y")
      flash.now[:alert] = @order.errors.full_messages.to_sentence
      render(:new, status: :unprocessable_entity)
    end
  end

  def load_payment_form
    @order = Order.new
    @payment = Payment.new
    respond_to do |format|
      format.turbo_stream { render partial: "payment_form" }
    end
  end

  def update
    if @order.update(order_params)
      redirect_to(admin_order_path(@order), notice: "Pedido atualizado com sucesso !!!")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @order.destroy!
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

class OrderMailer < ApplicationMailer
  def send_order_receipt(order_id)
    @order = Order.find(order_id)
    @customer = Customer.find_by(id: @order.customer_id)
    @equipament = Equipament.find_by(id: @order.equipament_id)
    mail(to: @customer.email,
         subject: "Seu Pedido - #{@order.order_code}")
  end

  def send_order_payment(order_id)
    @order = Order.find(order_id)
    @customer = Customer.find_by(id: @order.customer_id)
    @equipament = Equipament.find_by(id: @order.equipament_id)
    mail(to: @customer.email, subject: "Pagamento aprovado, pedido #{@order.order_code}")
  end

  def send_order_canceled(order_id)
    @order = Order.find(order_id)
    @customer = Customer.find_by(id: @order.customer_id)
    @equipament = Equipament.find_by(id: @order.equipament_id)
    mail(to: @customer.email, subject: "Cancelamento pedido #{@order.order_code}")
  end

  def send_payment_receipt(appointment_id)
    @appointment = Appointment.find_by(id: appointment_id)
    @payment = Payment.find_by(appointment_id:)
    @user = User.find_by(id: @appointment.client_id)
    mail(to: "from@example.com", from: @user.email,
         subject: "Pagamento realizado - Agendamento #{@appointment.appointment_code}")
  end

  def send_return_approved(appointment_id)
    @appointment = Appointment.find_by(id: appointment_id)
    @payment = Payment.find_by(appointment_id:)
    @user = User.find_by(id: @appointment.client_id)
    mail(to: @user.email, subject: "Seu pagamento foi aprovado")
  end

  def send_return_unapproved(appointment_id)
    @appointment = Appointment.find_by(id: appointment_id)
    @payment = Payment.find_by(appointment_id:)
    @user = User.find_by(id: @appointment.client_id)
    mail(to: @user.email, subject: "Seu pagamento não foi aprovado")
  end
end

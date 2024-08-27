# app/controllers/contacts_controller.rb
class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @name = params[:contact][:name]
    @subject = params[:contact][:subject]
    @message = params[:contact][:message]
    @contact_email = params[:contact][:email]
    @contact = Contact.new(contact_params)
    if @contact.valid?
      ContactMailer.contact_email(@contact.name, @contact.email, @contact.subject, @contact.message).deliver_later
      flash[:notice] = "Mensagem enviada com sucesso!"
      redirect_to root_path
    else
      flash.now[:alert] = "Houve um erro no envio da mensagem."
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end

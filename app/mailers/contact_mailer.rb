class ContactMailer < ApplicationMailer

  default from: 'equiporent@email.com'

  def contact_email(name, email, subject, message)
    @name = name
    @message = message
    @contact_email = email
    @subject = subject
    mail(to: 'contact@equiporent.com', subject: subject, reply_to: email)
  end

end

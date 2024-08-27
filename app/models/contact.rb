class Contact
  include ActiveModel::Model

  attr_accessor :name, :email, :subject, :message

  validates :name, presence: { message: "não pode ficar em branco" }
  validates :email, presence: { message: "não pode ficar em branco" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "formato inválido" }
  validates :subject, presence: { message: "não pode ficar em branco" }
  validates :message, presence: { message: "não pode ficar em branco" }
end

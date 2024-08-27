class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  validates :name, :mobile_phone, :identification, presence: true
  validates :dob, presence: true, if: -> { identification.length < 15 }
  validates :email, presence: true, uniqueness: true

  # Valida o formato do CPF ou CNPJ
  validates_format_of :identification,
    with: /\A(\d{3}\.\d{3}\.\d{3}-\d{2}|\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2})\z/,
      message: "não está no formato correto (CPF: 999.999.999-99 ou CNPJ: 99.999.999/9999-99)"

  validate :cpf_or_cnpj_valid

  def self.ransack_attributes(*)
    ["name"]
  end

  private

  def cpf_or_cnpj_valid
    if CPF.valid?(identification) || CNPJ.valid?(identification)
      true
    else
      errors.add(:identification, 'não é um CPF ou CNPJ válido')
    end
  end




end

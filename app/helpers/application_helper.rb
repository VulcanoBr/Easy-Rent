
module ApplicationHelper
  include Pagy::Frontend

  def format_currency(value)
    number_to_currency(value, unit: "R$", separator: ",", delimiter: ".")
  end
end

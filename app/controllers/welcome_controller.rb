# frozen_string_literal: true

class WelcomeController < ApplicationController

  include Pagy::Backend

  before_action :authenticate_customer!, only: %i[ rental_history ]

  def index
    @equipaments = Equipament.where(status: 'available').order('RANDOM()').limit(3)
  end

  def sobre; end

  def privacidade_termos; end

  def contato; end

  def list_equipament
    if params[:search].present?
      @pagy, @equipaments = pagy(Equipament.where('LOWER(name) LIKE ?', "%#{params[:search].downcase}%")
                               .where(status: ['available', 'unavailable'])
                               .order(:status), limit: 8)
    else
      @pagy, @equipaments = pagy(Equipament.where(status: ['available', 'unavailable']).order(:status), limit: 9)
    end
  end

  def details_equipament
    @equipament = Equipament.find(params[:id])
  end

  def rental_history
    @pagy, @order_history = pagy(current_customer.orders.order(created_at: :desc), limit: 4)
  end
end

# frozen_string_literal: true
module Admin
  class CustomersController < Admin::AdminController
    include Pagy::Backend

    before_action :load_customer, only: %i[show edit update destroy]

    def index
      if params[:search].present?
        @pagy, @customers = pagy(Customer.where('LOWER(name) LIKE ?', "%#{params[:search].downcase}%"), limit: 7)
      else
        @pagy, @customers = pagy(Customer.order(:name), limit: 7)
      end
      authorize(@customers)
    end

    def search
      @customers = Customer.where('lower(name) ILIKE ?', "%#{params[:q]}%".downcase) # ransack(name_matches: params[:q])

      render(layout: false)
    end

    def show
      authorize(@customer)
    end

    def new
      @customer = Customer.new
      authorize(@customer)
    end

    def edit
      authorize(@customer)
    end

    def create
      @customer = Customer.new(customer_params)
      authorize(@customer)
      if @customer.save
        redirect_to(admin_customer_url(@customer), notice: 'Cliente cadastrado com sucesso !!!')
      else
        render(:new, status: :unprocessable_entity)
      end
    end

    def update
      authorize(@customer)
      if @customer.update(customer_params)
        redirect_to(admin_customer_path(@customer), notice: 'Cliente atualizado com sucesso !!!')
      else
        render(:edit, status: unprocessable_entity)
      end
    end

    def destroy
      authorize(@customer)
      @customer.destroy!
    end

    private

    def load_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:name, :dob, :mobile_phone, :email, :address, :identification)
    end
  end
end

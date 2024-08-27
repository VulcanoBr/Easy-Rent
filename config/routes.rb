Rails.application.routes.draw do

  devise_for :customers, path: '', path_names: { sign_in: 'login', sign_out: 'logout',
      sign_up: 'register' }, controllers: { registrations: 'customers/registrations' }

  namespace :admin do

    devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
    root to: 'dashboard#index', as: 'dashboard'

    resources :customers do
      collection do
        get :search
      end
      member do
        delete :destroy_cover_image
      end
    end

    resources :equipaments do
      collection do
        get :search
      end
      member do
        delete :destroy_avatar_image
      end
    end

    resources :maintenances

    resources :orders do
      collection do
        get :put_fineshed_order
        get :put_canceled_order
        get :put_paid_order
      end
      member do
        get :cancel_order
        get :payment_order
        get :finished_order
        delete :destroy_category_image
      end
    end
  end

  get "sobre", to: "welcome#sobre"
  get "privacidade_termos", to: "welcome#privacidade_termos"
  get "list_equipament", to: "welcome#list_equipament"
  get 'welcome/details_equipament/:id', to: 'welcome#details_equipament', as: 'details_equipament'
  get 'welcome/rental_history', to: 'welcome#rental_history', as: 'my_rental_history'

  resources :rentals, only: [:new, :create, :show]

  resources :contacts, only: [:new, :create]

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "welcome#index"
end

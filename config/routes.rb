Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
}

  root 'home#index'
  get '/home',          to: 'home#index'
  get '/dashboard',     to: 'dashboard#index'
  get '/transactions',  to: 'transaction_records#index'

  resources :stocks, only: [:index, :show, :new, :create] do
    resources :orders
  end
end

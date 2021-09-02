Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
}

  resources :stocks

  root 'home#index'
  get '/home',          to: 'home#index'
  get '/dashboard',     to: 'dashboard#index'
end

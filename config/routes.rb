Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, 
             path: '',
             path_names: { sign_in: '', sign_out: 'logout' }, 
             controllers: {
               sessions: 'users/sessions',
               passwords: 'users/passwords',
               registrations: 'users/registrations'
  }

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  get '/home',          to: 'home#index'
  get '/dashboard',     to: 'dashboard#index'
end

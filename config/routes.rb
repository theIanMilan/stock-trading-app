Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
}

  root 'home#index'
  get '/home',          to: 'home#index'
  get '/dashboard',     to: 'dashboard#index'
end

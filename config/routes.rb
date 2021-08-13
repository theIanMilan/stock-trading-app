Rails.application.routes.draw do
  devise_for :user

  root 'home#index'
  get '/home',          to: 'home#index'
  get '/dashboard',     to: 'dashboard#index'
end

Rails.application.routes.draw do
  devise_for :users
  post 'transactions', to: 'transactions#create'
  post 'accounts', to: 'accounts#create'
  get 'accounts', to: 'accounts#list'
  get 'accounts/:id', to: 'accounts#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

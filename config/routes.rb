Rails.application.routes.draw do
  post 'transactions', to: 'transactions#create'
  get 'accounts/:id', to: 'accounts#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  get 'exchange_tasks', to: 'exchange_task#index'
  get 'exchange_tasks/new', to: 'exchange_task#new'
  post 'exchange_tasks', to: 'exchange_task#create'
  resources :accounts
  devise_for :users
  root 'accounts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

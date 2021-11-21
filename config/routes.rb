Rails.application.routes.draw do
  get 'exchange_tasks', to: 'exchange_task#index'
  get 'exchange_tasks/new', to: 'exchange_task#new'
  get 'exchange_tasks/delete/:jid', to: 'exchange_task#delete', as: 'exchange_delete'
  post 'exchange_tasks', to: 'exchange_task#create'
  get 'recharge/:id', to: 'accounts#recharge', as: 'recharge'
  post 'recharge/:id', to: 'accounts#recharge_it'

  resources :accounts
  devise_for :users
  root 'accounts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

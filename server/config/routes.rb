Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'authenticate', to: 'users#authenticate'
  resources :users, only: [:create]
  
  resources :thoughts, only: [:create, :index]
end

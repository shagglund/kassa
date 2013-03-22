Kassa::Application.routes.draw do
  resources :buys, only: [:index, :show, :create]

  resources :products, only: [:index, :show, :create, :update, :destroy]
  resources :materials, only: [:index, :show, :create, :update, :destroy]
  resources :users, only: [:index, :create, :update, :show] do
    get :current, on: :collection
  end

  devise_for :user
  root to: 'application#index'
end

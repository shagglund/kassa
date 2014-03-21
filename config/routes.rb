Kassa::Application.routes.draw do
  resources :buys, only: [:index, :show, :create]
  resources :products, only: [:index, :show, :create, :update] do
    resources :buys, only: :index
  end

  resources :users, only: [:index, :create, :update, :show] do
    get :me, on: :collection
    resources :buys, only: :index
  end

  devise_for :user

  get '/app(*path)', to: 'application#index'
  root to: redirect('/app')
end

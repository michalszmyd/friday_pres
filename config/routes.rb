Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :home, only: :show, controller: :home
  resources :posts do
    resources :comments, only: :create
    resources :reactions, only: :create
    resources :likes, only: :create do
      delete :destroy, on: :collection
    end
  end
end

Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/signup',     to: 'users#new'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'
  resources :users do
    member do
      get    :following, :followers
      post   :follow
      delete :unfollow
    end
    resources :tweets,  only: [:create, :destroy]
    resources :rooms,  only: [:index, :show, :new, :create, :destroy] do
      resources :messages,  only: [:new, :create, :destroy]
      member do
        post :mark_read
      end
    end
  end
end

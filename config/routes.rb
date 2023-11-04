Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :tweets, only: [:create, :show] do
    resources :likes, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
    resources :retweets, only: [:create, :destroy]
    resources :reply_tweets, only: [:create]
  end

  resources :bookmarks, only: :index

  get :dashboard, to: "dashboard#index"
  get :profile, to: "profile#show"
  put :profile, to: "profile#update"

  resources :usernames, only: [:new, :update]

  # this was used before but I read that nested routes are most fit for parent child relationships
  # resources :users, only: :show do
  #   resources :follows, only: [:create, :destroy]
  # end

  resources :users, only: :show

  post '/users/:follower_id/follows/:followed_id', to: "follows#create", as: :create_follow
  delete '/follows/:id', to: "follows#destroy", as: :delete_follow

  resources :hashtags, only: [:index, :show], path: "/explore"

  resources :channels, only: [:index], path: "/messages"

  resources :messages, only: [:create]
end

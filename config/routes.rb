Rails.application.routes.draw do
  namespace :api do
    resources :users
    resources :forums
    resources :topics
    resources :posts
    resources :votes
    resources :topic_saves
    resources :conversations
    resources :messages
    resources :sessions, only: [:show, :create, :destroy]
  end

  mount_ember_app :frontend, to: "/"
  get '*path' => redirect('/')
end

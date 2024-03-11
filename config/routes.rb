Rails.application.routes.draw do
  get 'artists/show'
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :artists, only: %i[show]

  get 'search', to: 'search#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end

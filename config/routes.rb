Rails.application.routes.draw do
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :artists, only: %i[show]
  resources :releases, only: %i[show]

  resources :items, only: %i[new create edit update destroy]

  get 'want_items', to: 'items#index', defaults: { view_type: 'want_items' }
  get 'collection_items', to: 'items#index', defaults: { view_type: 'collection_items' }

  get 'search', to: 'search#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end

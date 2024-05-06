Rails.application.routes.draw do
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :artists, only: %i[show]
  resources :releases, only: %i[show]
  resource :my_page, only: %i[show]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
  resources :records do
    collection do
      get :search
      get 'daily_records/:date', to: 'records#daily_records', as: :daily_records
    end
  end
  resources :items, only: %i[new create show edit update destroy] do
    member do
      patch :move_to_collection
    end
  end

  get 'terms', to: 'static_pages#terms', as: 'terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: 'privacy_policy'
  get 'collection_tag_items', to: 'tags#index', defaults: { view_type: 'collection_items' }
  get 'want_tag_items', to: 'tags#index', defaults: { view_type: 'want_items' }
  get 'collection_items', to: 'items#index', defaults: { view_type: 'collection_items' }
  get 'want_items', to: 'items#index', defaults: { view_type: 'want_items' }
  get 'search', to: 'search#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end

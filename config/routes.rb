Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'static_pages#top'
  resources :users, only: %i[new create destroy]
  resources :artists, only: %i[show]
  resources :releases, only: %i[show]
  resources :password_resets, only: %i[new create edit update]
  resources :shop_bookmarks, only: %i[create destroy]
  resource :my_page, only: %i[show]
  resource :profile, only: %i[show edit update]
  resource :email, only: %i[edit update]

  resources :records do
    collection do
      get :search
      get 'daily_records/:date', to: 'records#daily_records', as: :daily_records
      get 'report_show', as: :report_show
      get :change_month
      get 'report_show', to: 'records#report_show', as: :report_show_records
    end
  end

  resources :items, only: %i[new create show edit update] do
    member do
      patch :move_to_collection
      patch :soft_delete
    end
  end

  resources :shops, only: %i[show] do
    collection do
      get 'map'
      get 'image', to: 'shops#shop_image'
      get :bookmarks
      get :review_shops
    end
    resources :reviews, only: %i[new create edit update destroy], shallow: true
  end

  get 'terms', to: 'static_pages#terms', as: 'terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: 'privacy_policy'
  get 'collection_tag_items', to: 'tags#collection_tag_items'
  get 'want_tag_items', to: 'tags#want_tag_items'
  get 'collection_items', to: 'items#collection_items'
  get 'want_items', to: 'items#want_items'
  get 'search', to: 'search#index'
  get 'confirm_email/:token', to: 'emails#confirm_email', as: 'confirm_email'
  get 'email_change_confirmation', to: 'emails#email_change_confirmation'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end

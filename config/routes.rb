Rails.application.routes.draw do
  root 'meditations#index'
  resources :frames
  resources :meditations
  resources :users do
    get :track
  end
end

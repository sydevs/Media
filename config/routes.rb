Rails.application.routes.draw do
  root 'meditations#index'
  resources :frames
  resources :meditations
end

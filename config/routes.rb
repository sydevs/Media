Rails.application.routes.draw do
  root 'meditations#index'
  resources :frames
  
  resources :meditations do
    get :recut, on: :member
  end

  resources :users do
    get :track, on: :member
  end
end

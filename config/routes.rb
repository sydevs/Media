Rails.application.routes.draw do
  root 'meditations#index'
  resources :frames
  resources :musics
  
  resources :meditations do
    get :recut, on: :member
    get 'tagged/(:tag)', on: :collection, action: :tagged
  end

  resources :users do
    get :home, on: :collection
    #get :home, on: :member
    get :track, on: :member
  end
end

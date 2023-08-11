Rails.application.routes.draw do
  root 'meditations#index'

  resources :musics, :frames do
    get 'tag/(:tag)', on: :collection, action: :index, as: :tagged
  end
  
  resources :meditations do
    get :recut, on: :member
    get 'tagged/(:tag)', on: :collection, action: :tagged
    get 'tag/(:tag)', on: :collection, action: :index, as: :tagged
  end

  resources :users do
    get :home, on: :collection
    #get :home, on: :member
    get :track, on: :member
  end
end

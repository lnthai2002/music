Music::Engine.routes.draw do
  resources :songs do
    collection do
      get :scan
    end
  end
#  match 'songs/download/:id'=>'songs#download', :id => /[^\/]+/

  delete 'logout', to: 'sessions#logout'

  root :to => 'songs#index'
end

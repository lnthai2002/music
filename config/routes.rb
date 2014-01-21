Music::Engine.routes.draw do
  resources :drb_servers
  resources :songs do
    collection do
      get :scan
      get :load_tags
      post :write_tags
    end
  end
#  match 'songs/download/:id'=>'songs#download', :id => /[^\/]+/

  get 'song/streamfile', to: 'songs#streamfile', as: :streamfile 
  delete 'logout', to: 'sessions#logout'

  root :to => 'songs#index'
end

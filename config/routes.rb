Music::Engine.routes.draw do
  resources :songs
#  match 'songs/download/:id'=>'songs#download', :id => /[^\/]+/

  delete 'logout', to: 'sessions#logout'

  root :to => 'songs#index'
end

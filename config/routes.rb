Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  # this has the same effect of -> resources :articles, only: [:show, :index, :new, :create, :edit, :update]
  resources :articles
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  #TODO: shouldn't it be a post request instead a GET request? the turbo_method just works if I change here toa GET request
  get 'logout', to: 'sessions#destroy' 
  resources :categories, except: [:destroy]
end

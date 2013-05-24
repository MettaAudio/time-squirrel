TaskRabbit::Application.routes.draw do
  resources :issues


  resources :tasks


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end
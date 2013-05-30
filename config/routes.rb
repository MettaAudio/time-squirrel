TaskRabbit::Application.routes.draw do

  resources :projects
  resources :tasks
  resources :timers, :expect => [:new, :index]

  match "start_timer" => "timers#start_timer", :as => :start_timer
  match "stop_timer"  => "timers#stop_timer",  :as => :stop_timer

  match 'sync_tasks' => "tasks#sync_tasks", :as => :sync_tasks

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end
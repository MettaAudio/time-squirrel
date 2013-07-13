TimeSquirrel::Application.routes.draw do

  resources :projects
  resources :tasks
  resources :timers, :expect => [:new, :create, :index]
  resources :harvest_projects, :expect => [:new, :create]

  match "daily_total" => "home#daily", :as => :daily

  match "start_timer" => "timers#start_timer", :as => :start_timer
  match "stop_timer"  => "timers#stop_timer",  :as => :stop_timer

  match 'sync_jira_tasks' => "sync#sync_jira_tasks", :as => :sync_jira
  match 'sync_harvest_tasks' => "sync#sync_harvest_tasks", :as => :sync_harvest
  match 'push_harvest_entries' => "sync#push_harvest_entries", :as => :push_harvest_entries

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end
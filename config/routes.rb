Rails.application.routes.draw do

  devise_for :users
  root to: "pages#home"
  
  resources :public_runs, only: [:index, :show], path: 'explore'
  resources :guardians, except: [:index, :show]
  resources :runs, except: [:index] do
      member do
        patch "start", to: "runs#start_run", as: :start
        patch "pause", to: "runs#pause_run", as: :pause
        patch "resume", to: "runs#resume_run", as: :resume
        patch "end", to: "runs#end_run", as: :end
        patch :make_public
        post :start_alert, to: 'guardian_notifications#run_start_alert'
        post :end_alert, to: "guardian_notifications#run_end_alert"
        post :over_time_alert, to: "guardian_notifications#over_time_alert"
        post :incident_alert, to: "guardian_notifications#incident_alert"
        get :share
      end
      resources :positions, only: :create
      resources :run_badges, only: :create
      resources :guardian_notifications, only: :create
    end
  resources :badges, only: [:index, :show]

  get "/profile", to: "pages#profile", as: :profile

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")

end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Letter Opener Web - Preview emails in development
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root "coffee_records#index"
  get "records", to: redirect("/coffee_records")
  get "coffee_records/taste", to: "coffee_records#taste", as: :coffee_records_taste
  post "coffee_records/taste", to: "coffee_records#taste_create", as: :coffee_records_taste_create
  resources :coffee_records, only: [:index, :new, :create, :edit, :destroy] do
    member do
      patch :update_brew, path: "brew"
      get :edit_taste
      patch :update_taste, path: "taste"
    end
  end
  get "settings", to: "settings#index", as: :settings
end

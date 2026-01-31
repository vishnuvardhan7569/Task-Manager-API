Rails.application.routes.draw do
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"
  get "/me", to: "users#me"

  resources :projects do
    resources :tasks
  end

  root to: proc { [ 200, {}, [ "Task Manager Api is Running" ] ] }
end

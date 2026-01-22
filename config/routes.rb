Rails.application.routes.draw do
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"

  resources :projects do
    resources :tasks, shallow: true
  end

  root to: proc { [ 200, {}, [ "Task Manager Api is Running" ] ] }
end

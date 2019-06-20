Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get "room", to: "room#index"
  get "room/question", to: "room#question"
  resources :users do
    collection do
      post :login
      get :login_page
      post :logout
    end
  end
end

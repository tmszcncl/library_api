Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :books, only: [ :index, :show, :create, :destroy ], param: :serial_number do
    member do
      post "borrow/:reader_card_number", action: :borrow, as: :borrow
      post :return
    end
  end
end

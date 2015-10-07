Rails.application.routes.draw do
  resources :albums, only: [:index]
  root "albums#index"
end

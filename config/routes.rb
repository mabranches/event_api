Rails.application.routes.draw do
  resources :events, except: [:new, :edit]
  root "events#index"
end

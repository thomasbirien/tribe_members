Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tribe_members, only: [:new, :create, :index]
  root 'tribe_members#index'
  get "tribe_members/show_stats", to: "tribe_members#show_stats"
end

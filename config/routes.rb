Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tribe_members, only: [:index, :new, :create]
  root 'tribe_members#index'
end

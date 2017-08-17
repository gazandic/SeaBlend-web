Rails.application.routes.draw do
  resources :image_blend, only: [:index, :create]
  root to: 'image_blend#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

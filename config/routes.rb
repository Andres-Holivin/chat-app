Rails.application.routes.draw do
  root "home#index"
  
  resources :messages, only: [:index, :create]
  
  mount ActionCable.server => '/cable'
  
  get '*path', to: 'home#index', constraints: ->(request) do
    !request.xhr? && request.format.html?
  end
end

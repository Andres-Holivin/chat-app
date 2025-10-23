Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Silence Chrome DevTools requests
  get ".well-known/appspecific/com.chrome.devtools.json" => proc { [404, {}, ['']] }
  
  root "home#index"
  
  resources :messages, only: [:index, :create]
  
  mount ActionCable.server => '/cable'
  
  get '*path', to: 'home#index', constraints: ->(request) do
    !request.xhr? && request.format.html?
  end
end

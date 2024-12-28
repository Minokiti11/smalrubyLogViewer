Rails.application.routes.draw do
  get 'logs/show', to: 'logs#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "logs#show"
end

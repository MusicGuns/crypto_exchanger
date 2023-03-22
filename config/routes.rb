Rails.application.routes.draw do
  resources :transactions, only: %i[new index create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'rate', to: 'rates#rate'
  root to: 'transactions#new'
end

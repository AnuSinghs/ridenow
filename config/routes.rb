Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users
  resources :listings, only: [ :index ]
  resources :journeys, only: [ :index, :show, :create, :edit, :update, :destroy] do
    member do
      get :route_email
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/my-journeys', to: 'journeys#my_journeys'
  get '/editorial', to: 'pages#editorial'

end

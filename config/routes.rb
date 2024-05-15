Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "playlists#index"

  # Spotify API 사용할 경우 필요
  #get '/auth/spotify/callback', to: 'sessions#create'

  resources :playlists, only: [:index, :create] do
    member do
      get 'apple_music_playlist', to: 'playlists#apple_music_playlist'
    end
  end

  resources :tracks, only: [:index]
end

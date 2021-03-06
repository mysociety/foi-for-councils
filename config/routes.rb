# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  root to: redirect('foi')

  namespace :foi do
    root to: 'requests#index'

    resource :request, except: %i[show destroy] do
      root to: redirect('foi/request/new')

      resources :suggestions, only: %i[index]

      get 'contact', to: redirect('foi/request/contact/new')
      resource :contact, except: %i[show destroy]

      get 'preview', to: 'submissions#new', as: 'preview'
      post 'send', to: 'submissions#create', as: 'send'
      get 'sent', to: 'submissions#show', as: 'sent'
    end
  end

  resources :links, only: %i[show]

  namespace :admin do
    root action: 'show'

    resources :curated_links, except: [:show] do
      collection do
        resource :export, only: [:show], format: 'csv'
      end
    end

    resource :performance, only: %i[show new create]

    get 'help', to: 'help#index', as: :help
  end

  namespace :health do
    root to: redirect('/health/metrics')

    resources :metrics, only: [:index], format: 'txt'
  end

  get '/auth/failure', to: 'sessions#new'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/sign_in', to: 'sessions#new'
  delete '/auth/sign_out', to: 'sessions#destroy'

  resolve('FoiRequest') { %i[foi request] }

  mount Sidekiq::Web => '/sidekiq'
end

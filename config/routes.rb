# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('foi/requests')

  namespace :foi do
    root to: redirect('foi/requests')
    resources :requests, except: %i[destroy] do
      resources :suggestions, only: %i[index]
      resource :contact, only: %i[show update], path: 'contact'
      resource :submission, only: %i[update], path: 'send', as: 'send'
      resource :submission, only: %i[show], path: 'sent', as: 'sent'
    end
  end
end

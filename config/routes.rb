# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  use_doorkeeper scope: 'api/v1/sessions' do
    skip_controllers :authorizations, :applications, :authorized_applications
    controllers tokens: 'api/v1/oauth_tokens'
  end

  mount Sidekiq::Web => '/sidekiq' # monitoring console
  apipie

  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create do
        delete '/', action: :destroy, on: :collection
      end
    end
  end
end

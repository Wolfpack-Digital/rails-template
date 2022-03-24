# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  mount Sidekiq::Web => '/sidekiq' # monitoring console
  apipie
end

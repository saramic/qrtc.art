# frozen_string_literal: true

Rails.application.routes.draw do
  resources :locations, only: %i[index show new create update]
  get "/:id" => "locations#show"
  root to: "locations#index"
end

# frozen_string_literal: true

Rails.application.routes.draw do
  mount Flipper::UI.app(Flipper) => "/flipper"

  get "test_root", to: "rails/welcome#index", as: "test_root_rails"

  resources :locations, only: %i[index show new edit create update] do
    collection do
      get :print
      get :list
    end
    member do
      get :qr
    end
  end

  get "/qr/:id" => "locations#qr"
  get "/:id" => "locations#show"
  root to: "locations#index"
end

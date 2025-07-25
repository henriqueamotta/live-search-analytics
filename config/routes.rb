Rails.application.routes.draw do
  post "/searches", to: "searches#create"

  get "/analytics", to: "analytics#index"

  get "/analytics/trends", to: "analytics#trends"

  root "analytics#index"

  get "up" => "rails/health#show", as: :rails_health_check
end

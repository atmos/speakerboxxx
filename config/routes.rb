Rails.application.routes.draw do

  mount Peek::Railtie => "/peek"

  get  "/auth/failure",         to: "sessions#destroy"
  get  "/auth/github/callback", to: "sessions#create_github"
  get  "/auth/slack/callback",  to: "sessions#create_slack"

  get "/health", to: "application#health"
  get "/boomtown", to: "application#boomtown"

  get "/support", to: "pages#support"

  post "/webhooks/:team_id/github/:org_name", to: "webhooks#create"

  post "/commands", to: "commands#create"
  post "/signout", to: "sessions#destroy"

  root to: "pages#index"
end

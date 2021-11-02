Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'search#index'

  # search
  post 'search', to: 'search#search_from_home'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'search#index'

  # search
  get '/search', to: 'search#results'

  # book
  get '/book/:id', to: 'book#show'
  get '/book', to: redirect('/')
end

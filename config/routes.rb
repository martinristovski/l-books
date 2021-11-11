Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'search#index'

  # sign up
  get '/signup', to: 'registrations#new'
  post '/signup', to: 'registrations#create'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create', as: 'log_in'
  delete 'logout', to: 'sessions#destroy'
  get 'password', to: 'passwords#edit', as: 'edit_password'
  patch 'password', to: 'passwords#update'
  get 'password/reset', to: 'password_resets#new'
  post 'password/reset', to: 'password_resets#create'
  get 'password/reset/edit', to: 'password_resets#edit'
  patch 'password/reset/edit', to: 'password_resets#update'

  # search
  get '/search', to: 'search#results'

  # book
  get '/book/:id', to: 'book#show'
  get '/book', to: redirect('/')

  # listing
  get '/listing/:id', to: 'listing#show'
  get '/listing', to: redirect('/')

  # coverage
  get '/coverage', :to => redirect('/index.html')
end

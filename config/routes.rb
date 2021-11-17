Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'search#index'

  # sign up
  get '/signup', to: 'registrations#new'
  post '/signup', to: 'registrations#create'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create', as: 'log_in'
  get 'logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
  get 'password', to: 'passwords#edit', as: 'edit_password'
  patch 'password', to: 'passwords#update'
  get 'password/reset', to: 'password_resets#new'
  post 'password/reset', to: 'password_resets#create'
  get 'password/reset/edit', to: 'password_resets#edit'
  patch 'password/reset/edit', to: 'password_resets#update'

  # search
  get '/search', to: 'search#results'

  # book
  get '/book', to: redirect('/')
  resources :book do
    get '/book/:id', to: 'book#show'
  end

  # listing
  get '/listing', to: redirect('/')
  get '/listing/new', to: 'listing#new'
  post '/listing/new', to: 'listing#new'
  get '/listing/:id/edit', to: 'listing#edit'
  post '/listing/:id/edit', to: 'listing#edit'
  get '/listing/:id/delete', to: 'listing#delete'
  delete '/listing/:id/delete', to: 'listing#delete'
  resources :listing do
    get '/listing/:id', to: 'listing#show'
  end

  # coverage
  get '/cov_rspec', :to => redirect('/cov_rspec/index.html')
  get '/cov_cucumber', :to => redirect('/cov_cucumber/index.html')
end

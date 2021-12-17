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
  post '/listing/new/uploadimg', to: 'listing#new__upload_image'
  post '/listing/new', to: 'listing#new__finalize'
  post '/listing/new/deleteimg/:imgid', to: 'listing#new__delete_uploaded_image'

  post '/listing/:id/edit/uploadimg', to: 'listing#edit__upload_image'
  post '/listing/:id/edit/deleteimg/:imgid', to: 'listing#edit__delete_uploaded_image'
  get '/listing/:id/edit', to: 'listing#edit'
  post '/listing/:id/edit', to: 'listing#edit'
  get '/listing/:id/bookmark', to: 'listing_bookmark#create'

  get '/listing/:id/sold', to: 'listing#sold'
  post '/listing/:id/sold', to: 'listing#sold'

  get '/listing/:id/delete', to: 'listing#delete'
  delete '/listing/:id/delete', to: 'listing#delete'

  resources :listing do
    get '/listing/:id', to: 'listing#show'
  end

  # coverage
  get '/cov_rspec', :to => redirect('/cov_rspec/index.html')
  get '/cov_cucumber', :to => redirect('/cov_cucumber/index.html')
end

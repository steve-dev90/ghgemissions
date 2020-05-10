Rails.application.routes.draw do
  root 'static_pages#home'

  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/emissions_form', to: 'emissions_form#index'

  namespace :emissions do
    resources :dashboard
    resources :power_emissions
  end

end

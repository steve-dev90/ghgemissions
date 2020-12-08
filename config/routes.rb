Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/disclaimer', to: 'static_pages#disclaimer'
  get '/emissions_form', to: 'emissions_form#index'

  namespace :emissions do
    resources :dashboard
    resources :power_emissions
  end
end

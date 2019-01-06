Rails.application.routes.draw do
  root 'application#hello'
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/contact'
  resources :emissions
end

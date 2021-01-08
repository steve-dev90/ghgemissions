class ApplicationController < ActionController::Base
  # To perform put, patch, delete requests from API, we need to add following code to
  protect_from_forgery with: :null_session
end

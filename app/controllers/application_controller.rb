# class ApplicationController < ActionController::Base
class ApplicationController < ActionController::API   # for API mode
  # protect_from_forgery with: :exception     # disable in API mode
end

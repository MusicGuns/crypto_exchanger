class ApplicationController < ActionController::Base
  KEY = Bitcoin::Key.from_base58(ENV['PRIVATE_KEY'])
end

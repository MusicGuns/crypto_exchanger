class ApplicationRecord < ActiveRecord::Base
  include Bitcoin::Builder
  primary_abstract_class
  BLOCKSTREAM_API = 'https://blockstream.info/testnet/api/'
  KEY = Bitcoin::Key.from_base58(ENV['PRIVATE_KEY'])
end

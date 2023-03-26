class ApplicationRecord < ActiveRecord::Base
  include Bitcoin::Builder
  primary_abstract_class
end

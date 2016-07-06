# Top-level DB Record used across the app
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

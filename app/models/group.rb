class Group < ActiveRecord::Base
  # association macros
  has_and_belongs_to_many :users
end

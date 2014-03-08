class Debit < ActiveRecord::Base
  # association macros
  has_many :users

  # validation
  validates :balance, :presence => true, numericality: true
end

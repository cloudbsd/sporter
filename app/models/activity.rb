class Activity < ActiveRecord::Base
  belongs_to :group
  has_many :fee_items
end

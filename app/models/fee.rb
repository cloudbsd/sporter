class Fee < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :fee_items
end

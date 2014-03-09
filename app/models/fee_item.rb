class FeeItem < ActiveRecord::Base
  belongs_to :activity
  belongs_to :fee
end

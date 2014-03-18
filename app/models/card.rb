class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :card_type
end

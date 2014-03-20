class Card < ActiveRecord::Base
  # the default scope first (if any)
  scope :valid_cards, lambda { where("cards.number > ?", 0) }

  belongs_to :user
  belongs_to :card_type
  has_many :participants

  def else_number
    number - participants.size - participants.sum('friend_number')
  end
end

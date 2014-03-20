class Card < ActiveRecord::Base
  # the default scope first (if any)
  scope :valid_cards, lambda { where("cards.number > ?", 0) }

  belongs_to :user
  belongs_to :card_type
  has_many :participants

  def remaining_number
    if number == 0
      0
    else
      number - participants.size - participants.sum('friend_number')
    end
  end

  def is_valid?
    (self.stopped_at > DateTime.now.to_date) && (self.number == 0 || self.remaining_number > 0)
  end
end

class Card < ActiveRecord::Base
  # the default scope first (if any)
  scope :debits, lambda { joins(:card_type).where(:card_types => { kind: 'debit' }) }
  scope :valid_cards, lambda { where("cards.number > ?", 0) }
  scope :up_to_date, lambda { where("cards.stopped_at > ?", DateTime.now.to_date) }
#   (self.stopped_at > DateTime.now.to_date) && (self.number == 0 || self.remaining_number > 0)

  # association macros
  belongs_to :user
  belongs_to :card_type
  has_many :participants
  has_many :transactions

  # instance methods
  def is_debit_card?
    self.card_type.kind == 'debit'
  end

  def is_number_card?
    self.card_type.kind == 'number'
  end

  def is_period_card?
    self.card_type.kind == 'period'
  end

  def remaining_number
    number
  # if number == 0
  #   0
  # else
  #   number - participants.size - participants.sum('friend_number')
  # end
  end

  def calculate_number
    self.number = self.card_type.number - self.participants.size - self.participants.sum('friend_number')
    self.save
  end

  def calculate_balance
    self.balance = self.transactions.sum('amount')
  end

  def is_valid?
    (self.stopped_at > DateTime.now.to_date) && (self.number == 0 || self.remaining_number > 0)
  end
end

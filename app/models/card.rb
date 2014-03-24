class Card < ActiveRecord::Base
  # the default scope first (if any)
  scope :debits, lambda { |group_id| joins(:card_type).where(:card_types => { kind: 'debit', group_id: group_id }) }
  scope :in_group, lambda { |group_id| joins(:card_type).where(:card_types => { group_id: group_id }) }
  scope :valid_cards, lambda { where("cards.number > ?", 0) }
  scope :up_to_date, lambda { where("cards.stopped_at > ?", DateTime.now.to_date) }

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
    result = self.balance + self.transactions.sum('amount') - self.participants.sum('net_pay')
    if self.is_number_card?
      result.to_i
    else
      result
    end
  end

  def is_valid?
    (self.stopped_at > DateTime.now.to_date) && (self.number == 0 || self.remaining_number > 0)
  end
end
